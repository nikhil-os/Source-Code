const mongoose = require("mongoose");

const rentalSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    movie: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Movie",
      required: true,
    },
    durationHours: { type: Number, required: true },
    price: { type: Number, required: true },
    currency: { type: String, default: "USD" },
    purchasedAt: { type: Date, default: Date.now },
    expiresAt: { type: Date, required: true },
    status: { type: String, enum: ["active", "expired"], default: "active" },
    provider: { type: String, default: "dummy" },
    // store raw option for bookkeeping
    optionLabel: { type: String },
  },
  { timestamps: true, versionKey: false },
);

rentalSchema.index({ user: 1, movie: 1, status: 1 });

module.exports = mongoose.model("Rental", rentalSchema);
