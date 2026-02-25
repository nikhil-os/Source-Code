const mongoose = require("mongoose");
const Movie = require("./server/movie/movie.model");
const Genre = require("./server/genre/genre.model");
const Region = require("./server/region/region.model");
const Trailer = require("./server/trailer/trailer.model");

async function seedMovies() {
  try {
    // Wait for mongoose to connect (should already be connected via index.js)
    if (mongoose.connection.readyState !== 1) {
      console.log("Waiting for MongoDB connection...");
      await new Promise((resolve) => setTimeout(resolve, 2000));
    }

    console.log("Seeding dummy movies...");

    // Create multiple genres
    const genreNames = [
      "Action",
      "Sci-Fi",
      "Drama",
      "Thriller",
      "Adventure",
      "Romance",
      "Comedy",
    ];
    const genres = {};
    for (const name of genreNames) {
      let genre = await Genre.findOne({ name });
      if (!genre) {
        genre = await Genre.create({ name });
        console.log("Created genre:", genre.name);
      }
      genres[name] = genre;
    }

    // Create multiple regions
    const regionNames = ["USA", "India", "UK", "South Korea", "Japan"];
    const regions = {};
    for (const name of regionNames) {
      let region = await Region.findOne({ name });
      if (!region) {
        region = await Region.create({ name });
        console.log("Created region:", region.name);
      }
      regions[name] = region;
    }

    // Clear existing movies for fresh seed
    const existingCount = await Movie.countDocuments();
    if (existingCount > 0) {
      console.log(
        `Clearing ${existingCount} existing movies for fresh seed...`,
      );
      await Movie.deleteMany({});
      await Trailer.deleteMany({});
      console.log("Cleared existing movies and trailers.");
    }

    const dummyMovies = [
      {
        title: "The Dark Knight",
        image:
          "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
        thumbnail:
          "https://image.tmdb.org/t/p/w500/hkBaDkMWbLaf8B1lsWsKX7Ew3Xq.jpg",
        link: "https://www.youtube.com/watch?v=EXeTwQWrcwY",
        year: "2008",
        description:
          "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
        type: "Premium",
        runtime: "152 min",
        videoType: 0,
        media_type: "movie",
        region: regions["USA"]._id,
        genre: [
          genres["Action"]._id,
          genres["Thriller"]._id,
          genres["Drama"]._id,
        ],
        isNewRelease: false,
        view: 1250,
        comment: 45,
        TmdbMovieId: "155",
        IMDBid: "tt0468569",
        isRentable: true,
        rentalCurrency: "INR",
        rentalOptions: [
          { duration: 3, durationLabel: "3 Hours", price: 29 },
          { duration: 24, durationLabel: "24 Hours", price: 79 },
          { duration: 168, durationLabel: "7 Days", price: 149 },
        ],
      },
      {
        title: "Inception",
        image:
          "https://image.tmdb.org/t/p/w500/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg",
        thumbnail:
          "https://image.tmdb.org/t/p/w500/s3TBrRGB1iav7gFOCNx3H31MoES.jpg",
        link: "https://www.youtube.com/watch?v=YoHD9XEInc0",
        year: "2010",
        description:
          "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O., but his tragic past may doom the project and his team to disaster.",
        type: "Premium",
        runtime: "148 min",
        videoType: 0,
        media_type: "movie",
        region: regions["USA"]._id,
        genre: [
          genres["Action"]._id,
          genres["Sci-Fi"]._id,
          genres["Thriller"]._id,
        ],
        isNewRelease: false,
        view: 980,
        comment: 38,
        TmdbMovieId: "27205",
        IMDBid: "tt1375666",
        isRentable: true,
        rentalCurrency: "INR",
        rentalOptions: [
          { duration: 6, durationLabel: "6 Hours", price: 49 },
          { duration: 48, durationLabel: "2 Days", price: 99 },
          { duration: 720, durationLabel: "30 Days", price: 299 },
        ],
      },
      {
        title: "Interstellar",
        image:
          "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
        thumbnail:
          "https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
        link: "https://www.youtube.com/watch?v=zSWdZVtXT7E",
        year: "2014",
        description:
          "When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.",
        type: "Premium",
        runtime: "169 min",
        videoType: 0,
        media_type: "movie",
        region: regions["USA"]._id,
        genre: [
          genres["Sci-Fi"]._id,
          genres["Adventure"]._id,
          genres["Drama"]._id,
        ],
        isNewRelease: false,
        view: 1100,
        comment: 52,
        TmdbMovieId: "157336",
        IMDBid: "tt0816692",
        isRentable: true,
        rentalCurrency: "INR",
        rentalOptions: [
          { duration: 12, durationLabel: "12 Hours", price: 59 },
          { duration: 168, durationLabel: "7 Days", price: 179 },
        ],
      },
      {
        title: "Avatar",
        image:
          "https://image.tmdb.org/t/p/w500/jRXYjXNq0Cs2TcJjLkki24MLp7u.jpg",
        thumbnail:
          "https://image.tmdb.org/t/p/w500/o0s4XsEDfDlvit5pDRKjzXR4pp2.jpg",
        link: "https://www.youtube.com/watch?v=5PSNL1qE6VY",
        year: "2009",
        description:
          "A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.",
        type: "Free",
        runtime: "162 min",
        videoType: 0,
        media_type: "movie",
        region: regions["USA"]._id,
        genre: [
          genres["Action"]._id,
          genres["Adventure"]._id,
          genres["Sci-Fi"]._id,
        ],
        isNewRelease: false,
        view: 2500,
        comment: 89,
        TmdbMovieId: "19995",
        IMDBid: "tt0499549",
        isRentable: false,
      },
      {
        title: "The Matrix",
        image:
          "https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg",
        thumbnail:
          "https://image.tmdb.org/t/p/w500/ncEsesgOJDNrTUED89hYbA117wo.jpg",
        link: "https://www.youtube.com/watch?v=vKQi3bBA1y8",
        year: "1999",
        description:
          "When a beautiful stranger leads computer hacker Neo to a forbidding underworld, he discovers the shocking truth--the life he knows is the elaborate deception of an evil cyber-intelligence.",
        type: "Premium",
        runtime: "136 min",
        videoType: 0,
        media_type: "movie",
        region: regions["USA"]._id,
        genre: [genres["Action"]._id, genres["Sci-Fi"]._id],
        isNewRelease: false,
        view: 1800,
        comment: 67,
        TmdbMovieId: "603",
        IMDBid: "tt0133093",
        isRentable: true,
        rentalCurrency: "INR",
        rentalOptions: [
          { duration: 3, durationLabel: "3 Hours", price: 19 },
          { duration: 6, durationLabel: "6 Hours", price: 39 },
          { duration: 24, durationLabel: "24 Hours", price: 69 },
          { duration: 168, durationLabel: "7 Days", price: 129 },
          { duration: 720, durationLabel: "30 Days", price: 249 },
        ],
      },
      {
        title: "Avengers: Endgame",
        image:
          "https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg",
        thumbnail:
          "https://image.tmdb.org/t/p/w500/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg",
        link: "https://www.youtube.com/watch?v=TcMBFSGVi1c",
        year: "2019",
        description:
          "After the devastating events of Avengers: Infinity War, the universe is in ruins. With the help of remaining allies, the Avengers assemble once more in order to reverse Thanos actions and restore balance to the universe.",
        type: "Premium",
        runtime: "181 min",
        videoType: 0,
        media_type: "movie",
        region: regions["USA"]._id,
        genre: [
          genres["Action"]._id,
          genres["Adventure"]._id,
          genres["Sci-Fi"]._id,
        ],
        isNewRelease: true,
        view: 3500,
        comment: 125,
        TmdbMovieId: "299534",
        IMDBid: "tt4154796",
        isRentable: true,
        rentalCurrency: "INR",
        rentalOptions: [
          { duration: 24, durationLabel: "24 Hours", price: 99 },
          { duration: 168, durationLabel: "7 Days", price: 199 },
        ],
      },
      {
        title: "Parasite",
        image:
          "https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg",
        thumbnail:
          "https://image.tmdb.org/t/p/w500/TU9NIjwzjoKPwQHoHshkFcQUCG.jpg",
        link: "https://www.youtube.com/watch?v=5xH0HfJHsaY",
        year: "2019",
        description:
          "Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.",
        type: "Premium",
        runtime: "132 min",
        videoType: 0,
        media_type: "movie",
        region: regions["South Korea"]._id,
        genre: [
          genres["Thriller"]._id,
          genres["Drama"]._id,
          genres["Comedy"]._id,
        ],
        isNewRelease: true,
        view: 890,
        comment: 42,
        TmdbMovieId: "496243",
        IMDBid: "tt6751668",
        isRentable: true,
        rentalCurrency: "INR",
        rentalOptions: [
          { duration: 12, durationLabel: "12 Hours", price: 69 },
          { duration: 48, durationLabel: "2 Days", price: 119 },
        ],
      },
      {
        title: "Titanic",
        image:
          "https://image.tmdb.org/t/p/w500/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg",
        thumbnail:
          "https://image.tmdb.org/t/p/w500/kHXEpyfl6zqn8a6YuozZUujufXf.jpg",
        link: "https://www.youtube.com/watch?v=kVrqfYjkTdQ",
        year: "1997",
        description:
          "A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.",
        type: "Free",
        runtime: "194 min",
        videoType: 0,
        media_type: "movie",
        region: regions["USA"]._id,
        genre: [genres["Drama"]._id, genres["Romance"]._id],
        isNewRelease: false,
        view: 4200,
        comment: 156,
        TmdbMovieId: "597",
        IMDBid: "tt0120338",
        isRentable: false,
      },
      {
        title: "3 Idiots",
        image:
          "https://image.tmdb.org/t/p/w500/66A9MqXOyVFCssoloscw79z8Tew.jpg",
        thumbnail:
          "https://image.tmdb.org/t/p/w500/oC87S59x2g3epiHv8vD8P1yEICp.jpg",
        link: "https://www.youtube.com/watch?v=K0eDlFX9GMc",
        year: "2009",
        description:
          "Two friends are searching for their long lost companion. They revisit their college days and recall the memories of their friend who inspired them to think differently.",
        type: "Free",
        runtime: "170 min",
        videoType: 0,
        media_type: "movie",
        region: regions["India"]._id,
        genre: [genres["Comedy"]._id, genres["Drama"]._id],
        isNewRelease: false,
        view: 3100,
        comment: 98,
        TmdbMovieId: "20453",
        IMDBid: "tt1187043",
        isRentable: false,
      },
      {
        title: "Spirited Away",
        image:
          "https://image.tmdb.org/t/p/w500/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg",
        thumbnail:
          "https://image.tmdb.org/t/p/w500/bSXfU4dwZyBA1vMmXvejdRXBvuF.jpg",
        link: "https://www.youtube.com/watch?v=ByXuk9QqQkk",
        year: "2001",
        description:
          "During her familys move to the suburbs, a sullen 10-year-old girl wanders into a world ruled by gods, witches and spirits, where humans are changed into beasts.",
        type: "Premium",
        runtime: "125 min",
        videoType: 0,
        media_type: "movie",
        region: regions["Japan"]._id,
        genre: [genres["Adventure"]._id, genres["Drama"]._id],
        isNewRelease: false,
        view: 1650,
        comment: 72,
        TmdbMovieId: "129",
        IMDBid: "tt0245429",
        isRentable: true,
        rentalCurrency: "INR",
        rentalOptions: [
          { duration: 6, durationLabel: "6 Hours", price: 39 },
          { duration: 24, durationLabel: "24 Hours", price: 79 },
        ],
      },
    ];

    for (const movieData of dummyMovies) {
      const movie = await Movie.create(movieData);
      console.log("Created movie:", movie.title);

      // Create trailer for each movie
      const trailer = await Trailer.create({
        movie: movie._id,
        name: `${movie.title} - Official Trailer`,
        type: "Trailer",
        videoType: 0,
        videoUrl: movieData.link,
        trailerImage: movieData.thumbnail,
      });
      console.log("Created trailer for:", movie.title);
    }

    console.log("\n✅ All 10 dummy movies with trailers created successfully!");
  } catch (error) {
    console.error("Error seeding movies:", error.message);
    console.error(error);
  }
}

module.exports = seedMovies;

// If run directly
if (require.main === module) {
  seedMovies();
}
