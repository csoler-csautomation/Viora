import http from "node:http";

const port = Number(process.env.PORT || 3000);
const apiKey = process.env.OPENAI_API_KEY;
const model = process.env.OPENAI_VISION_MODEL || "gpt-5.6-luna";

function send(res, status, body) {
  res.writeHead(status, { "Content-Type": "application/json; charset=utf-8" });
  res.end(JSON.stringify(body));
}

async function readJSON(req) {
  const chunks = [];
  for await (const chunk of req) chunks.push(chunk);
  return JSON.parse(Buffer.concat(chunks).toString("utf8"));
}

const server = http.createServer(async (req, res) => {
  if (req.method === "GET" && req.url === "/health") {
    return send(res, 200, { status: "ok", service: "stareli-api" });
  }

  if (req.method === "POST" && req.url === "/v1/vision/analyze") {
    try {
      if (!apiKey) return send(res, 500, { error: "OPENAI_API_KEY is not configured" });

      const { question, imageBase64 } = await readJSON(req);
      if (!question || !imageBase64) {
        return send(res, 400, { error: "question and imageBase64 are required" });
      }

      const response = await fetch("https://api.openai.com/v1/responses", {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${apiKey}`,
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          model,
          input: [{
            role: "user",
            content: [
              { type: "input_text", text: `You are Stareli, an accessible visual assistant for blind and low-vision users. Answer clearly, directly, and describe useful spatial details when visible. User question: ${question}` },
              { type: "input_image", image_url: `data:image/jpeg;base64,${imageBase64}` }
            ]
          }],
          max_output_tokens: 500
        })
      });

      const data = await response.json();
      if (!response.ok) {
        console.error("OpenAI error", response.status, data?.error?.message || "Unknown error");
        return send(res, 502, { error: "OpenAI request failed" });
      }

      const answer = (data.output || [])
        .flatMap(item => item.content || [])
        .filter(item => item.type === "output_text")
        .map(item => item.text)
        .join("\n")
        .trim();

      if (!answer) return send(res, 502, { error: "OpenAI returned no text" });
      return send(res, 200, { answer });
    } catch (error) {
      console.error(error);
      return send(res, 500, { error: "Internal server error" });
    }
  }

  send(res, 404, { error: "Not found" });
});

server.listen(port, () => console.log(`Stareli API listening on port ${port}`));
