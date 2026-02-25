const mongoose = require("mongoose");

const connectAndSeed = async () => {
  try {
    // Will be updated with actual MongoDB port after server starts
    const mongoUri =
      process.env.MONGODB_CONNECTION_STRING ||
      "mongodb+srv://webtimeadmin:Admin10001@webtimemovieocean.4scvwbg.mongodb.net/webtimemovieocean?appName=webtimemovieocean";

    await mongoose.connect(mongoUri);
    console.log("Connected to MongoDB at:", mongoUri);

    const genreSchema = new mongoose.Schema(
      {
        name: { type: String, trim: true, default: "" },
        image: { type: String, trim: true, default: "" },
      },
      { timestamps: true, versionKey: false },
    );

    const regionSchema = new mongoose.Schema(
      {
        name: { type: String, trim: true, default: "" },
        image: { type: String, trim: true, default: "" },
      },
      { timestamps: true, versionKey: false },
    );

    const movieSchema = new mongoose.Schema(
      {
        title: { type: String, trim: true, default: "" },
        image: { type: String, trim: true, default: "" },
        thumbnail: { type: String, trim: true, default: "" },
        link: { type: String, trim: true, default: "" },
        date: { type: String, default: "" },
        year: { type: String, trim: true, default: "" },
        description: { type: String, trim: true, default: "" },
        type: { type: String, default: "Premium" },
        isNewRelease: { type: Boolean, default: false },
        region: { type: mongoose.Schema.Types.ObjectId, ref: "Region" },
        genre: [{ type: mongoose.Schema.Types.ObjectId, ref: "Genre" }],
        view: { type: Number, default: 0 },
        runtime: { type: String, default: "" },
        media_type: { type: String },
        videoType: { type: Number },
        isRentable: { type: Boolean, default: false },
        rentalCurrency: { type: String, default: "USD" },
        rentalOptions: [
          {
            duration: { type: Number, required: true },
            durationLabel: { type: String, required: true },
            price: { type: Number, required: true },
          },
        ],
      },
      { timestamps: true, versionKey: false },
    );

    const Genre = mongoose.models.Genre || mongoose.model("Genre", genreSchema);
    const Region =
      mongoose.models.Region || mongoose.model("Region", regionSchema);
    const Movie = mongoose.models.Movie || mongoose.model("Movie", movieSchema);

    // Create Genre
    const genre = await Genre.create({
      name: "Action",
      image:
        "https://images.unsplash.com/photo-1535016120720-40c646be5580?w=500",
    });
    console.log("✅ Genre created:", genre.name, "-", genre._id);

    // Create Region
    const region = await Region.create({
      name: "Hollywood",
      image:
        "https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=500",
    });
    console.log("✅ Region created:", region.name, "-", region._id);

    // Create Movie with Multiple Rental Options
    const movie = await Movie.create({
      title: "Test Rental Movie - The Action Hero",
      image:
        "https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500",
      thumbnail:
        "https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800",
      link: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      date: "2026-02-05",
      year: "2026",
      description:
        "This is a test movie to verify the rental feature with multiple duration options. An action-packed adventure film perfect for testing your rental system!",
      type: "Premium",
      isNewRelease: true,
      region: region._id,
      genre: [genre._id],
      view: 100,
      runtime: "2h 15m",
      media_type: "movie",
      videoType: 3,
      isRentable: true,
      rentalCurrency: "USD",
      rentalOptions: [
        { duration: 12, durationLabel: "12 Hours", price: 1.99 },
        { duration: 48, durationLabel: "48 Hours", price: 3.99 },
        { duration: 72, durationLabel: "72 Hours", price: 4.99 },
        { duration: 168, durationLabel: "7 Days", price: 6.99 },
        { duration: 336, durationLabel: "14 Days", price: 9.99 },
        { duration: 576, durationLabel: "24 Days", price: 14.99 },
      ],
    });

    console.log("\n========================================");
    console.log("🎬 RENTAL MOVIE CREATED SUCCESSFULLY!");
    console.log("========================================");
    console.log("Movie Title:", movie.title);
    console.log("Movie ID:", movie._id);
    console.log("Is Rentable:", movie.isRentable);
    console.log("Currency:", movie.rentalCurrency);
    console.log("\n📋 RENTAL OPTIONS:");
    console.log("----------------------------------------");
    movie.rentalOptions.forEach((opt, idx) => {
      console.log(
        `  ${idx + 1}. ${opt.durationLabel.padEnd(12)} - $${opt.price.toFixed(2)} USD`,
      );
    });
    console.log("----------------------------------------");
    console.log("\n✅ You can now test the rental feature in admin panel!");

    await mongoose.disconnect();
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error.message);
    process.exit(1);
  }
};

connectAndSeed();
