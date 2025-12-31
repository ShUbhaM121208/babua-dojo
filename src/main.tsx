import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import "./index.css";
import { logPerformanceMetrics, monitorWebVitals } from "./lib/performance";

// Enable performance monitoring in development
if (import.meta.env.DEV) {
  logPerformanceMetrics();
}

// Monitor Core Web Vitals in production
if (import.meta.env.PROD) {
  monitorWebVitals();
}

createRoot(document.getElementById("root")!).render(<App />);
