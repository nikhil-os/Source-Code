const { S3 } = require("@aws-sdk/client-s3");
const aws = require("aws-sdk");
const multer = require("multer");
const multerS3 = require("multer-s3");
const fs = require("fs");
const path = require("path");

// DigitalOcean S3 client (legacy aws-sdk v2)
const createDOS3Instance = (hostname, accessKeyId, secretAccessKey) => {
  return new aws.S3({
    accessKeyId,
    secretAccessKey,
    endpoint: new aws.Endpoint(hostname),
    s3ForcePathStyle: true,
  });
};

// AWS S3 client (aws-sdk v3 via @aws-sdk/client-s3)
const createAwsS3Client = () => {
  return new S3({
    region: settingJSON.awsRegion || "us-east-1",
    credentials: {
      accessKeyId: settingJSON.awsAccessKey,
      secretAccessKey: settingJSON.awsSecretKey,
    },
  });
};

const localStoragePath = path.join(__dirname, "..", "uploads");

if (!fs.existsSync(localStoragePath)) {
  fs.mkdirSync(localStoragePath, { recursive: true });
}

/**
 * Determine the S3 key (folder + filename) based on file type.
 * Videos go to raw/, images go to thumbnails/.
 */
const getS3Key = (req, file) => {
  // If a folder structure is explicitly provided, use it
  if (req.body.folderStructure) {
    return `${req.body.folderStructure}/${file.originalname}`;
  }
  // Otherwise, auto-detect based on mime type
  if (file.mimetype.startsWith("video/") || file.mimetype === "application/octet-stream") {
    return `raw/${file.originalname}`;
  }
  if (file.mimetype.startsWith("image/")) {
    return `thumbnails/${file.originalname}`;
  }
  return `uploads/${file.originalname}`;
};

const getActiveStorage = async () => {
  const settings = settingJSON;
  if (settings.storage.local) return "local";
  if (settings.storage.awsS3) return "aws";
  if (settings.storage.digitalOcean) return "digitalocean";
  return "local";
};

const uploadMiddleware = async (req, res, next) => {
  try {
    const activeStorage = await getActiveStorage();

    let storageOption;

    if (activeStorage === "local") {
      storageOption = multer.diskStorage({
        destination: (req, file, cb) => {
          cb(null, localStoragePath);
        },
        filename: (req, file, cb) => {
          cb(null, file.originalname);
        },
      });
    } else if (activeStorage === "digitalocean") {
      const digitalOceanS3 = createDOS3Instance(
        settingJSON.doHostname,
        settingJSON.doAccessKey,
        settingJSON.doSecretKey
      );
      storageOption = multerS3({
        s3: digitalOceanS3,
        bucket: settingJSON.doBucketName,
        acl: "public-read",
        key: (req, file, cb) => {
          const folder = req.body.folderStructure;
          cb(null, `${folder}/${file.originalname}`);
        },
      });
    } else if (activeStorage === "aws") {
      const awsS3Client = createAwsS3Client();
      storageOption = multerS3({
        s3: awsS3Client,
        bucket: settingJSON.awsBucketName,
        key: (req, file, cb) => {
          const s3Key = getS3Key(req, file);
          console.log("Uploading to S3 key:", s3Key);
          cb(null, s3Key);
        },
      });
    }

    multer({ storage: storageOption }).single("content")(req, res, next);
  } catch (error) {
    next(error);
  }
};

module.exports = uploadMiddleware;
