/**
 * Build the public URL for an uploaded file.
 * When AWS S3 is active and a CloudFront domain is configured,
 * the URL will use CloudFront for streaming/CDN delivery.
 */
const buildFileUrl = (req, activeStorage, s3Key) => {
  if (activeStorage === "local") {
    return `${process.env.baseURL}/uploads/${req.file.originalname}`;
  }

  if (activeStorage === "digitalocean") {
    const folder = req.body.folderStructure || "uploads";
    return `${settingJSON?.doEndpoint}/${folder}/${req.file.originalname}`;
  }

  if (activeStorage === "aws") {
    // Use CloudFront URL if configured, otherwise direct S3 URL
    if (settingJSON.cloudFrontDomain) {
      return `https://${settingJSON.cloudFrontDomain}/${s3Key}`;
    }
    return `${settingJSON.awsEndpoint}/${settingJSON.awsBucketName}/${s3Key}`;
  }

  return "";
};

const getActiveStorage = async () => {
  const settings = settingJSON;
  if (settings.storage.local) return "local";
  if (settings.storage.awsS3) return "aws";
  if (settings.storage.digitalOcean) return "digitalocean";
  return "local";
};

/**
 * Determine the S3 key based on file type.
 * Videos → raw/, Images → thumbnails/
 */
const getS3Key = (req, file) => {
  if (req.body.folderStructure) {
    return `${req.body.folderStructure}/${file.originalname}`;
  }
  if (file.mimetype.startsWith("video/") || file.mimetype === "application/octet-stream") {
    return `raw/${file.originalname}`;
  }
  if (file.mimetype.startsWith("image/")) {
    return `thumbnails/${file.originalname}`;
  }
  return `uploads/${file.originalname}`;
};

//upload single file
exports.uploadContent = async (req, res) => {
  try {
    if (!req?.file) {
      return res.status(200).json({ status: false, message: "Please upload a valid file." });
    }

    const activeStorage = await getActiveStorage();
    const s3Key = getS3Key(req, req.file);
    const url = buildFileUrl(req, activeStorage, s3Key);

    return res.status(200).json({
      status: true,
      message: "File uploaded successfully",
      url,
      s3Key,
    });
  } catch (error) {
    console.error("Upload Error:", error);
    return res.status(500).json({ status: false, message: error.message || "Internal Server Error" });
  }
};

//upload multiple files (bulk)
exports.bulkUploadContent = async (req, res) => {
  try {
    if (!req.files || req.files.length === 0) {
      return res.status(200).json({ status: false, message: "Please upload valid files." });
    }

    console.log("Multiple Upload started for admin side .......");

    const activeStorage = await getActiveStorage();
    const uploadedFiles = {};

    req.files.forEach((file) => {
      const s3Key = getS3Key(req, file);
      let fileUrl = "";

      if (activeStorage === "local") {
        fileUrl = `${process.env.baseURL}/uploads/${file.originalname}`;
      } else if (activeStorage === "digitalocean") {
        fileUrl = `${settingJSON?.doEndpoint}/${req.body?.folderStructure || "uploads"}/${file.originalname}`;
      } else if (activeStorage === "aws") {
        if (settingJSON.cloudFrontDomain) {
          fileUrl = `https://${settingJSON.cloudFrontDomain}/${s3Key}`;
        } else {
          fileUrl = `${settingJSON.awsEndpoint}/${settingJSON.awsBucketName}/${s3Key}`;
        }
      }

      if (file.mimetype.startsWith("image/")) {
        uploadedFiles.videoImage = fileUrl;
      } else if (file.mimetype.startsWith("video/") || file.mimetype === "application/octet-stream") {
        uploadedFiles.videoUrl = fileUrl;
      }
    });

    if (!uploadedFiles.videoImage || !uploadedFiles.videoUrl) {
      return res.status(200).json({
        status: false,
        message: "Both video image and video file must be uploaded.",
      });
    }

    return res.status(200).json({
      status: true,
      message: "Files uploaded successfully.",
      data: uploadedFiles,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({ status: false, message: error.message || "Internal Server Error" });
  }
};
