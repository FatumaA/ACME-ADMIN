// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { createClient } from "https://esm.sh/@supabase/supabase-js";
import { serve } from "https://deno.land/std@0.182.0/http/server.ts";
import { SmtpClient } from "https://deno.land/x/smtp@v0.7.0/mod.ts";

console.log("Send New User Email Function Init!");

const supaClient = createClient(
	Deno.env.get("SUPABASE_URL")!,
	Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

console.log(`Supabase client init - ${supaClient}`);
const smtp = new SmtpClient();

const corsHeaders = {
	"Access-Control-Allow-Origin": "*",
	"Access-Control-Allow-Headers":
		"authorization, x-client-info, apikey, content-type",
	"Content-Type": "application/json",
};

serve(async (req) => {
	if (req.method === "OPTIONS") {
		return new Response("ok", { headers: corsHeaders });
	}

	// create a new user
	const { email, password, name, role } = await req.json();

	console.log(`About to sign up new user - req }`);

	const { data, error } = await supaClient.auth.admin.createUser({
		email,
		password,
		user_metadata: { name, user_role: role },
	});

	console.log(`Response from sign up - ${data?.toString()}`);

	if (error) {
		// return res.status(500).send(error.message);
		return new Response(JSON.stringify(error), {
			headers: corsHeaders,
			status: 500,
		});
	}

	if (!error) {
		// send new user email
		console.log(`Sending email init`);

		await smtp.connectTLS({
			hostname: "smtp.gmail.com",
			port: 465,
			username: Deno.env.get("SEND_EMAIL")!,
			password: Deno.env.get("EMAIL_PWD")!,
		});

		try {
			console.log(`Trying to send email`);

			await smtp.send({
				from: Deno.env.get("SEND_EMAIL")!,
				to: email,
				subject: "Acme Corp - Login Details",
				content: `Hello ${name},\r, \r, Your login details are:\r, \r, Email: ${email}\r, Password: ${password}\r, \r, Please change your password upon logging in at http://localhost:3000/ \r, Kind Regards,\r, Acme Corp`,
			});

			console.log(`Email sent successfully`);
		} catch (error) {
			console.log(`Email send error - ${error.message}`);

			return new Response(error.message, {
				headers: corsHeaders,
				status: 500,
			});
		}

		await smtp.close();

		return new Response(
			JSON.stringify({
				done: true,
			}),
			{
				headers: corsHeaders,
			}
		);
	}
	return new Response(JSON.stringify({}), {
		headers: corsHeaders,
		status: 400,
	});
});
