// ApiConfig.ets
export const API_BASE_URL: string = getApiBaseUrl();

function getApiBaseUrl(): string {
  // Priority:
  // 1. User-saved value in preferences
  // 2. Environment variable from .env
  // 3. Default fallback value

  const stored = preferences.getSync("api_base_url", "") as string;

  return (
    stored ||
    process.env.API_BASE_URL ||
    "http://172.18.32.1:8080"
  );
}