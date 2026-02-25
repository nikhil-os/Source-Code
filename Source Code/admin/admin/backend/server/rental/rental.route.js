const express = require("express");
const router = express.Router();

const rentalController = require("./rental.controller");

// Dummy purchase: records a rental with expiry
router.post("/purchase", rentalController.purchase);

// Check access: returns hasAccess and rental info
router.get("/access", rentalController.access);

// List rentals by user
router.get("/", rentalController.listByUser);

module.exports = router;
