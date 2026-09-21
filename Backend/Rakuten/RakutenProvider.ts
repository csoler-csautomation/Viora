// Server-side reference implementation. Never ship this file with credentials embedded.
// Environment variables are injected by the hosting platform.

export type VioraProduct = {
  id: string;
  title: string;
  retailer: string;
  price: number | null;
  salePrice: number | null;
  currency: string;
  imageURL: string | null;
  productURL: string;
  description: string | null;
  category: string | null;
  sku: string | null;
  upc: string | null;
};

export class RakutenProvider {
  constructor(private readonly bearerToken: () => Promise<string>) {}

  async search(query: string, limit = 20): Promise<string> {
    const token = await this.bearerToken();
    const url = new URL("https://api.linksynergy.com/productsearch/1.0");
    url.searchParams.set("keyword", query);
    url.searchParams.set("language", "en_US");
    url.searchParams.set("max", String(Math.min(Math.max(limit, 1), 100)));

    const response = await fetch(url, {
      headers: { Authorization: `Bearer ${token}` }
    });

    if (!response.ok) {
      throw new Error(`Rakuten Product Search failed: ${response.status}`);
    }

    // Rakuten Product Search currently returns XML.
    // Parse/normalize XML in the backend route before returning JSON to iOS.
    return response.text();
  }
}
