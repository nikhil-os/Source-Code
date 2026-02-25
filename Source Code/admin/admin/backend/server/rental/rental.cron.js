const Rental = require("./rental.model");

async function expireOldRentals() {
  const now = new Date();
  try {
    const result = await Rental.updateMany(
      { status: "active", expiresAt: { $lte: now } },
      { $set: { status: "expired" } },
    );
    if (result.modifiedCount) {
      console.log(`[rental.cron] Expired rentals: ${result.modifiedCount}`);
    }
  } catch (err) {
    console.error("[rental.cron] Error expiring rentals:", err?.message || err);
  }
}

module.exports = { expireOldRentals };
