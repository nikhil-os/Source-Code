const mongoose = require("mongoose");

// Connect to the in-memory MongoDB (we need to find the port dynamically)
const connectAndSeed = async () => {
  try {
    // Get existing connection from running server or connect to default
    const mongoUri =
      process.env.MONGODB_CONNECTION_STRING ||
      "mongodb+srv://webtimeadmin:Admin10001@webtimemovieocean.4scvwbg.mongodb.net/webtimemovieocean?appName=webtimemovieocean";

    await mongoose.connect(mongoUri);
    console.log("Connected to MongoDB");

    // Define schemas
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
        comment: { type: Number, default: 0 },
        runtime: { type: String, default: "" },
        updateType: { type: Number, default: 1 },
        TmdbMovieId: { type: String, default: null },
        IMDBid: { type: String, default: null },
        media_type: { type: String },
        videoType: { type: Number },
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
    console.log("Genre created:", genre._id);

    // Create Region
    const region = await Region.create({
      name: "Hollywood",
      image:
        "https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=500",
    });
    console.log("Region created:", region._id);

    // Create Dummy Movie
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
        "This is a test movie created to verify the rental feature from the admin panel. An action-packed adventure featuring a hero who saves the day!",
      type: "Premium",
      isNewRelease: true,
      region: region._id,
      genre: [genre._id],
      view: 100,
      runtime: "2h 15m",
      updateType: 1,
      media_type: "movie",
      videoType: 3,
    });
    console.log("Movie created:", movie._id);
    console.log("\n=== SUCCESS ===");
    console.log("Dummy movie created successfully!");
    console.log("Movie Title:", movie.title);
    console.log("Movie ID:", movie._id);

    await mongoose.disconnect();
    process.exit(0);
  } catch (error) {
    console.error("Error:", error.message);
    process.exit(1);
  }
};

connectAndSeed();
