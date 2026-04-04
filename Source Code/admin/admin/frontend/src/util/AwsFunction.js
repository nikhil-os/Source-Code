// import AWS from "aws-sdk";
import {
  secretKey,
} from "./config";
import axios from "axios";

export const uploadFile = async (FileName, folderStructure) => {
  try {
    // 1. Attempt Presigned Upload (Direct to S3) to bypass Vercel timeout limits
    try {
      const presignRes = await axios.post(`file/presign-upload`, {
        fileName: FileName?.name,
        fileType: FileName?.type,
        folderStructure: folderStructure
      }, {
        headers: {
          key: secretKey
        }
      });

      if (presignRes.data?.status && presignRes.data?.presignedUrl) {
        // We received a presigned URL! Upload directly to S3 bypassing our backend
        const xhr = new XMLHttpRequest();
        await new Promise((resolve, reject) => {
          xhr.open("PUT", presignRes.data.presignedUrl, true);
          xhr.setRequestHeader("Content-Type", FileName?.type || "application/octet-stream");
          
          xhr.onload = () => {
             if (xhr.status === 200 || xhr.status === 201) {
               resolve();
             } else {
               reject(new Error("External S3 Configuration Error: Please verify AWS credentials and CORS policy. Status " + xhr.status));
             }
          };
          xhr.onerror = () => reject(new Error("S3 Direct Upload Network Error. Please check AWS S3 CORS Configuration."));
          xhr.send(FileName);
        });
        
        const returnUrl = presignRes.data.cloudFrontUrl || presignRes.data.presignedUrl.split('?')[0];
        return { resDataUrl: returnUrl, imageURL: returnUrl };
      } else {
        console.warn("Server did not provide presigned URL. Falling back to default proxy.", presignRes.data);
      }
    } catch (presignError) {
      if (presignError.message && presignError.message.includes("S3")) {
        throw presignError; // DO NOT fallback if S3 explicitly rejected the upload (e.g. revoked keys)
      }
      console.warn("Presigned URL request failed. Falling back to default proxy upload.", presignError);
    }

    // 2. Fallback: Normal Vercel Proxy upload (can cause 504 Gateway Timeout if backend hangs)
    const formData = new FormData();
    formData.append("folderStructure", folderStructure);
    formData.append("keyName", FileName?.name);
    formData.append("content", FileName);

    const response = await axios.post(`file/upload-file`, formData);
    const resDataUrl = response.data.url;
    const imageURL = response.data.signedUrl || response.data.url;

    console.log("fallback response: ", response);
    return { resDataUrl, imageURL };
  } catch (error) {
    console.error("Upload process fully failed:", error);
    throw error;
  }
};

export const covertURl = async (FileName) => {
  try {
    // const spaceEndpoint = new AWS.Endpoint(hostname);
    // const s3 = new AWS.S3({
    //   endpoint: spaceEndpoint,
    //   accessKeyId: aws_access_key_id,
    //   secretAccessKey: aws_secret_access_key,
    // });
    // const params = {
    //   Bucket: bucketName,
    //   Key: folderStructurePath + FileName,
    //   Expires: 60,
    // };
    // const imageURL = await new Promise((resolve, reject) => {
    //   s3.getSignedUrl("getObject", params, (err, url) => {
    //     if (err) {
    //       console.error("Error generating presigned URL:", err);
    //       reject(err);
    //       return;
    //     }
    //     resolve(url);
    //   });
    // });
    // return { FileName, imageURL };
  } catch (error) {
    console.error("Error converting URL: ", error);
    throw error;
  }
};
