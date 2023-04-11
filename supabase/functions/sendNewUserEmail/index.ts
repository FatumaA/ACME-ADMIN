// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.182.0/http/server.ts";
import { SmtpClient } from "denomailer";
import { supabaseClient } from "https://deno.land/x/supabase_deno/mod.ts";

console.log("Hello from Functions!");
const sbclient = supabaseClient(
	"https://xlvhpbcxavkjwhvvumjr.supabase.co",
	"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzOTIyNDEzNSwiZXhwIjoxOTU0ODAwMTM1fQ.HZ4d4SdD40txeDY71d010S914KgrKYJNAzkrRU0C07w"
);
const smtp = new SmtpClient();

serve(async (_req) => {
	await sbclient.auth.signUp();
	await smtp.connect({
		hostname: Deno.env.get("SMTP_HOSTNAME")!,
		port: Number(Deno.env.get("SMTP_PORT")!),
		username: Deno.env.get("SMTP_USERNAME")!,
		password: Deno.env.get("SMTP_PASSWORD")!,
	});

	try {
		await smtp.send({
			from: Deno.env.get("SMTP_FROM")!,
			to: "testr@test.de",
			subject: `Hello from Supabase Edge Functions`,
			content: `Hello Functions \o/`,
		});
	} catch (error) {
		return new Response(error.message, { status: 500 });
	}

	await smtp.close();

	return new Response(
		JSON.stringify({
			done: true,
		}),
		{
			headers: { "Content-Type": "application/json" },
		}
	);
});
// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'
