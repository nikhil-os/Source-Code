//import mongoose
const mongoose = require("mongoose");

//import cors
const cors = require("cors");

//import express
const express = require("express");
const app = express();

//import path
const path = require("path");

//fs
const fs = require("fs");

//dotenv
require("dotenv").config({ path: ".env" });

app.use(cors());
app.use(express.json({ extended: false, limit: "3gb" }));
app.use(express.urlencoded({ extended: false, limit: "3gb" }));
app.use(express.static(path.join(__dirname, "public")));

// Simple health endpoint available even if DB hasn't connected yet
app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

//logging middleware
const logger = require("morgan");
app.use(logger("dev"));

//import model
const Setting = require("./server/setting/setting.model");

//settingJson
const settingJson = require("./setting");

//Declare global variable
global.settingJSON = {};

//handle global.settingJSON when pm2 restart
async function initializeSettings() {
  try {
    const setting = await Setting.findOne().sort({ createdAt: -1 });
    if (setting) {
      console.log("In setting initialize Settings");
      global.settingJSON = setting;
    } else {
      global.settingJSON = settingJson;
    }
  } catch (error) {
    console.error("Failed to initialize settings:", error);
  }
}

module.exports = initializeSettings();

//Declare the function as a global variable to update the setting.js file
global.updateSettingFile = (settingData) => {
  const settingJSON = JSON.stringify(settingData, null, 2);
  fs.writeFileSync("setting.js", `module.exports = ${settingJSON};`, "utf8");

  global.settingJSON = settingData; // Update global variable
  console.log("Settings file updated.");
};

// Optional: use in-memory MongoDB for local dev when no MongoDB is installed
async function connectDatabase() {
  let mongoUri = process.env.MONGODB_CONNECTION_STRING;
  if (process.env.USE_IN_MEMORY_DB === "true") {
    try {
      const { MongoMemoryServer } = require("mongodb-memory-server");
      console.log("Starting in-memory MongoDB...");
      const mongod = await MongoMemoryServer.create({
        instance: {
          dbName: "webtime_movie_ocean",
        },
        binary: {
          version: "6.0.4",
        },
      });
      mongoUri = mongod.getUri();
      console.log("Using in-memory MongoDB at:", mongoUri);
      await mongoose.connect(mongoUri);
      console.log("Connected to in-memory MongoDB successfully");
      return;
    } catch (err) {
      console.error("Failed to start in-memory MongoDB:", err?.message || err);
      console.error("Full error:", err);
      console.log("Falling back to:", mongoUri);
    }
  }

  try {
    await mongoose.connect(mongoUri);
  } catch (err) {
    console.error("Mongo connection error:", err?.message || err);
  }
}

connectDatabase();

//mongoose connection
const db = mongoose.connection;
db.on("error", (err) => {
  console.error("connection error:", err);
});

db.once("open", async () => {
  console.log("Mongo: successfully connected to db");
  await initializeSettings();

  // Seed dummy movies for testing
  try {
    const seedMovies = require("./seed_dummy_movies");
    await seedMovies();
  } catch (err) {
    console.error("Failed to seed movies:", err?.message || err);
  }

  const routes = require("./route");
  app.use(routes);

  app.get("/*", (req, res) => {
    res.status(200).sendFile(path.join(__dirname, "public", "index.html"));
  });

  // Start rental expiry cron (hourly)
  try {
    const { expireOldRentals } = require("./server/rental/rental.cron");
    // run once on boot
    expireOldRentals();
    // run every hour
    setInterval(expireOldRentals, 60 * 60 * 1000);
    console.log("Rental expiry cron scheduled (hourly)");
  } catch (err) {
    console.error(
      "Failed to schedule rental expiry cron:",
      err?.message || err,
    );
  }
});

app.use("/uploads", express.static(path.join(__dirname, "uploads")));

//Set port and listen the request
// Global error handlers to avoid silent crashes
process.on("uncaughtException", (err) => {
  console.error("Uncaught Exception:", err);
});
process.on("unhandledRejection", (reason) => {
  console.error("Unhandled Rejection:", reason);
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => {
  console.log("Hello World!! listening on 0.0.0.0:" + PORT);
});
