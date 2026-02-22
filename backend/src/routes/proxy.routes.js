// Image Proxy Route - to bypass CORS for external images
import express from "express";
import https from "https";
import http from "http";

const router = express.Router();

// GET /proxy/image?url=<encoded-url>
router.get("/image", async (req, res) => {
  try {
    const imageUrl = req.query.url;
    
    if (!imageUrl) {
      return res.status(400).json({ error: "URL parameter required" });
    }

    // Determine protocol
    const protocol = imageUrl.startsWith('https') ? https : http;

    // Fetch the image
    protocol.get(imageUrl, (imageRes) => {
      // Set appropriate headers
      res.setHeader('Content-Type', imageRes.headers['content-type'] || 'image/jpeg');
      res.setHeader('Access-Control-Allow-Origin', '*');
      res.setHeader('Cache-Control', 'public, max-age=86400'); // Cache for 24 hours
      
      // Pipe the image to response
      imageRes.pipe(res);
    }).on('error', (err) => {
      console.error('Error fetching image:', err);
      res.status(500).json({ error: 'Failed to fetch image' });
    });

  } catch (error) {
    console.error('Proxy error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;
