import fetch from "node-fetch";
import dotenv from "dotenv";

dotenv.config();
const BASE_URL = "https://api.surveymonkey.com/v3";
const TOKEN = process.env.SURVEYMONKEY_ACCESS_TOKEN;

// get survey
export async function getSurvey(id) {
    const res = await fetch(`${BASE_URL}/surveys/${id}/details`, {
        headers:
            {"Authorization": `Bearer ${TOKEN}`,
            "Content-Type": "application/json"}
    });
    const data = await res.json();
    return data;
}

// submit survey 
// if successful, can extract response id and check if submitted
export async function submitSurvey(collectorId, answers) {
    const res = await fetch(`${BASE_URL}/collectors/${collectorId}/responses`, {
        method: "POST",
        headers: {
            "Authorization": `Bearer ${TOKEN}`,
            "Content-Type": "application/json"
        },
        body: JSON.stringify(answers)
    });

    const data = await res.json();
    return {
        status: res.status,
        data
    };
}

export async function getCollectors(surveyId) {
  const res = await fetch(
    `${BASE_URL}/surveys/${surveyId}/collectors`,
    {
      headers: {
        Authorization: `Bearer ${TOKEN}`,
        "Content-Type": "application/json"
      }
    }
  );

  const data = await res.json();
  return data;
}


