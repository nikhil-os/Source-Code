import React, { useState, useEffect } from "react";
import { Modal, Button, Form, Table, Spinner } from "react-bootstrap";
import { useDispatch } from "react-redux";
import axios from "axios";
import { baseURL, secretKey } from "../../util/config";
import { Toast } from "../../util/Toast_";

// Fixed rental duration options as per requirement
const RENTAL_DURATION_OPTIONS = [
  { duration: 3, durationLabel: "3 Hours" },
  { duration: 6, durationLabel: "6 Hours" },
  { duration: 12, durationLabel: "12 Hours" },
  { duration: 24, durationLabel: "24 Hours" },
  { duration: 48, durationLabel: "2 Days" },
  { duration: 168, durationLabel: "7 Days" },
  { duration: 360, durationLabel: "15 Days" },
  { duration: 504, durationLabel: "21 Days" },
  { duration: 720, durationLabel: "30 Days" },
];

const RentalDialog = ({ show, onHide, movie, onSave }) => {
  const [isRentable, setIsRentable] = useState(false);
  const [rentalCurrency, setRentalCurrency] = useState("INR");
  const [rentalOptions, setRentalOptions] = useState([]);
  const [saving, setSaving] = useState(false);

  // Initialize rental options from movie data or defaults
  useEffect(() => {
    if (movie) {
      setIsRentable(movie.isRentable || false);
      setRentalCurrency(movie.rentalCurrency || "INR");

      // Map existing rental options or create defaults with empty prices
      const existingOptions = movie.rentalOptions || [];
      const mappedOptions = RENTAL_DURATION_OPTIONS.map((opt) => {
        const existing = existingOptions.find(
          (e) => e.duration === opt.duration,
        );
        return {
          duration: opt.duration,
          durationLabel: opt.durationLabel,
          price: existing ? existing.price : "",
        };
      });
      setRentalOptions(mappedOptions);
    }
  }, [movie, show]);

  const handlePriceChange = (index, value) => {
    const updated = [...rentalOptions];
    updated[index].price = value === "" ? "" : Number(value);
    setRentalOptions(updated);
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      // Filter out options with empty or zero prices for saving
      const validOptions = rentalOptions.filter(
        (opt) => opt.price !== "" && opt.price > 0,
      );

      const response = await axios.patch(
        `${baseURL}movie/update?movieId=${movie._id}`,
        {
          isRentable,
          rentalCurrency,
          rentalOptions: JSON.stringify(validOptions),
        },
        {
          headers: {
            key: secretKey,
          },
        },
      );

      if (response.data.status) {
        Toast("success", "Rental settings saved successfully!");
        if (onSave) {
          onSave(response.data.movie);
        }
        onHide();
      } else {
        Toast(
          "error",
          response.data.message || "Failed to save rental settings",
        );
      }
    } catch (error) {
      console.error("Error saving rental settings:", error);
      Toast("error", "Error saving rental settings");
    } finally {
      setSaving(false);
    }
  };

  const getCurrencySymbol = (currency) => {
    switch (currency) {
      case "INR":
        return "₹";
      case "USD":
        return "$";
      case "EUR":
        return "€";
      default:
        return "₹";
    }
  };

  return (
    <Modal show={show} onHide={onHide} centered size="lg">
      <Modal.Header closeButton className="bg-dark text-white">
        <Modal.Title>
          <i className="ri-shopping-cart-2-line me-2"></i>
          Rental Settings - {movie?.title}
        </Modal.Title>
      </Modal.Header>
      <Modal.Body className="bg-dark text-white">
        <Form>
          {/* Enable Rental Toggle */}
          <Form.Group className="mb-4">
            <div className="d-flex align-items-center">
              <Form.Check
                type="switch"
                id="rental-switch"
                checked={isRentable}
                onChange={(e) => setIsRentable(e.target.checked)}
                className="me-2"
              />
              <Form.Label htmlFor="rental-switch" className="mb-0">
                Enable Rental for this Movie
              </Form.Label>
            </div>
            <Form.Text className="text-muted">
              When enabled, users can rent this movie for the durations you
              specify.
            </Form.Text>
          </Form.Group>

          {isRentable && (
            <>
              {/* Currency Selection */}
              <Form.Group className="mb-4">
                <Form.Label>Currency</Form.Label>
                <Form.Select
                  value={rentalCurrency}
                  onChange={(e) => setRentalCurrency(e.target.value)}
                  style={{ maxWidth: "200px" }}
                >
                  <option value="INR">INR (₹)</option>
                  <option value="USD">USD ($)</option>
                  <option value="EUR">EUR (€)</option>
                </Form.Select>
              </Form.Group>

              {/* Rental Options Table */}
              <Form.Group className="mb-3">
                <Form.Label className="d-block mb-3">
                  Rental Duration & Pricing
                </Form.Label>
                <p className="text-muted small mb-3">
                  Set the price for each rental duration. Leave empty to disable
                  that option.
                </p>
                <Table bordered hover variant="dark" responsive>
                  <thead>
                    <tr>
                      <th style={{ width: "50%" }}>Duration</th>
                      <th style={{ width: "50%" }}>
                        Price ({getCurrencySymbol(rentalCurrency)})
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {rentalOptions.map((option, index) => (
                      <tr key={index}>
                        <td className="align-middle">
                          <span className="fw-medium">
                            {option.durationLabel}
                          </span>
                        </td>
                        <td>
                          <div className="input-group">
                            <span className="input-group-text bg-secondary border-secondary">
                              {getCurrencySymbol(rentalCurrency)}
                            </span>
                            <Form.Control
                              type="number"
                              min="0"
                              step="0.01"
                              placeholder="Enter price"
                              value={option.price}
                              onChange={(e) =>
                                handlePriceChange(index, e.target.value)
                              }
                            />
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </Table>
              </Form.Group>
            </>
          )}
        </Form>
      </Modal.Body>
      <Modal.Footer className="bg-dark">
        <Button variant="secondary" onClick={onHide} disabled={saving}>
          Cancel
        </Button>
        <Button variant="danger" onClick={handleSave} disabled={saving}>
          {saving ? (
            <>
              <Spinner animation="border" size="sm" className="me-2" />
              Saving...
            </>
          ) : (
            <>
              <i className="ri-save-line me-1"></i>
              Save Settings
            </>
          )}
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default RentalDialog;
