// import AWS from "aws-sdk";
// import {
//   folderStructurePath,
// } from "./config";
import axios from "axios";

export const uploadFile = async (FileName, folderStructure) => {
  try {
    const formData = new FormData();
    formData.append("folderStructure", folderStructure);
    formData.append("keyName", FileName?.name);
    formData.append("content", FileName);

    const response = await axios.post(`file/upload-file`, formData);
    const resDataUrl = response.data.url;
    const imageURL = response.data.signedUrl;

    console.log('response: ', response);
    return { resDataUrl, imageURL };
  } catch (error) {
    console.error(error);
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
