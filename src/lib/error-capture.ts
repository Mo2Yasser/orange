import { supabase } from "./integrations/supabase/client";

export async function captureError(error: unknown, context?: string) {
  console.error("Captured Error:", error, context);
  try {
    await supabase.from("error_logs").insert({
      error_message: String(error),
      context: context || "general",
      created_at: new Date().toISOString()
    });
  } catch (e) {
    console.error("Failed to log error to Supabase:", e);
  }
}
