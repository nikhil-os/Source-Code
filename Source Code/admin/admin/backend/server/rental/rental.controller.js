const Rental = require("./rental.model");
const Movie = require("../movie/movie.model");

exports.purchase = async (req, res) => {
  try {
    const { userId, movieId, durationHours } = req.body;
    if (!userId || !movieId || !durationHours) {
      return res
        .status(400)
        .json({
          status: false,
          message: "userId, movieId and durationHours are required",
        });
    }

    const movie = await Movie.findById(movieId);
    if (!movie)
      return res
        .status(404)
        .json({ status: false, message: "Movie not found" });
    if (!movie.isRentable)
      return res
        .status(400)
        .json({ status: false, message: "Movie is not rentable" });

    const opt = (movie.rentalOptions || []).find(
      (o) => Number(o.duration) === Number(durationHours),
    );
    if (!opt)
      return res
        .status(400)
        .json({ status: false, message: "Invalid rental option" });

    const now = new Date();
    const expiresAt = new Date(
      now.getTime() + Number(durationHours) * 60 * 60 * 1000,
    );

    const doc = await Rental.create({
      user: userId,
      movie: movieId,
      durationHours: Number(durationHours),
      price: Number(opt.price),
      currency: movie.rentalCurrency || "USD",
      expiresAt,
      optionLabel: opt.durationLabel,
      provider: "dummy",
    });

    return res.json({
      status: true,
      message: "Rental purchased (dummy)",
      rental: doc,
    });
  } catch (error) {
    console.error("rental.purchase error", error);
    return res.status(500).json({ status: false, message: error.message });
  }
};

exports.access = async (req, res) => {
  try {
    const { userId, movieId } = req.query;
    if (!userId || !movieId)
      return res
        .status(400)
        .json({ status: false, message: "userId and movieId are required" });

    const now = new Date();
    let rental = await Rental.findOne({ user: userId, movie: movieId }).sort({
      expiresAt: -1,
    });
    if (rental && rental.expiresAt <= now && rental.status !== "expired") {
      // auto-mark expired
      rental.status = "expired";
      await rental.save();
    }
    const hasAccess = rental
      ? rental.status === "active" && rental.expiresAt > now
      : false;
    return res.json({ status: true, hasAccess, rental });
  } catch (error) {
    return res.status(500).json({ status: false, message: error.message });
  }
};

exports.listByUser = async (req, res) => {
  try {
    const { userId } = req.query;
    if (!userId)
      return res
        .status(400)
        .json({ status: false, message: "userId is required" });
    const rentals = await Rental.find({ user: userId }).populate("movie");
    return res.json({ status: true, rentals });
  } catch (error) {
    return res.status(500).json({ status: false, message: error.message });
  }
};
