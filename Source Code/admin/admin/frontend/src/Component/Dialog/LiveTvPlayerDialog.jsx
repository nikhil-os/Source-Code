import React from "react";
import { Dialog, DialogContent, IconButton } from "@mui/material";
import { IoClose } from "react-icons/io5";
import ReactPlayer from "react-player";

const LiveTvPlayerDialog = ({ open, onClose, streamURL, channelName }) => {
  return (
    <Dialog open={open} onClose={onClose} maxWidth="md" fullWidth>
      <div className="flex justify-between items-center p-3 border-b">
        <h4 className="text-lg font-semibold">{channelName}</h4>
        <IconButton onClick={onClose}>
          <IoClose />
        </IconButton>
      </div>
      <DialogContent>
        <ReactPlayer
          url={streamURL}
          playing={open}
          controls
          width="100%"
          height="480px"
        />
      </DialogContent>
    </Dialog>
  );
};

export default LiveTvPlayerDialog;
