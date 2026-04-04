const { S3, PutObjectCommand } = require("@aws-sdk/client-s3");
const { getSignedUrl } = require("@aws-sdk/s3-request-presigner");

/**
 * Generate a pre-signed URL for direct browser-to-S3 uploads.
 * This is useful for large video files (avoids sending through Express).
 *
 * POST /file/presign-upload
 * Body: { fileName, fileType, folderStructure }
 *   folderStructure: "raw" for videos, "thumbnails" for images
 *
 * Returns: { presignedUrl, s3Key, cloudFrontUrl }
 */
exports.presignUpload = async (req, res) => {
  try {
    const { fileName, fileType, folderStructure } = req.body;

    if (!fileName || !fileType) {
      return res.status(200).json({
        status: false,
        message: "fileName and fileType are required.",
      });
    }

    // Determine folder
    let folder = folderStructure || "uploads";
    if (!folderStructure) {
      if (fileType.startsWith("video/")) {
        folder = "raw";
      } else if (fileType.startsWith("image/")) {
        folder = "thumbnails";
      }
    }

    const s3Key = `${folder}/${fileName}`;

    const s3Client = new S3({
      region: settingJSON.awsRegion || "us-east-1",
      credentials: {
        accessKeyId: settingJSON.awsAccessKey,
        secretAccessKey: settingJSON.awsSecretKey,
      },
    });

    const command = new PutObjectCommand({
      Bucket: settingJSON.awsBucketName,
      Key: s3Key,
      ContentType: fileType,
    });

    // Pre-signed URL valid for 1 hour (3600 seconds)
    const presignedUrl = await getSignedUrl(s3Client, command, {
      expiresIn: 3600,
    });

    // Build the final access URL (CloudFront or direct S3)
    let cloudFrontUrl;
    if (settingJSON.cloudFrontDomain) {
      cloudFrontUrl = `https://${settingJSON.cloudFrontDomain}/${s3Key}`;
    } else {
      cloudFrontUrl = `https://${settingJSON.awsBucketName}.s3.${settingJSON.awsRegion}.amazonaws.com/${s3Key}`;
    }

    return res.status(200).json({
      status: true,
      message: "Pre-signed URL generated successfully",
      presignedUrl,
      s3Key,
      cloudFrontUrl,
    });
  } catch (error) {
    console.error("Presign Error:", error);
    return res.status(500).json({
      status: false,
      message: error.message || "Internal Server Error",
    });
  }
};
