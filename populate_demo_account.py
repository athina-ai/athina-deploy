import requests
import json
import random

url = "http://localhost:9000/api/v1/log/inference"

headers = {
    "athina-api-key": ""
}
dataset_filepath = "demo-prompt-runs.json"

def log():
    # Read the dataset
    with open(dataset_filepath) as f:
        dataset = json.load(f)

    dataset = dataset[2:]

    # Log the data
    for data in dataset:
        print(f"Logging query: {data['query']}")
        log_data(data["context"], data["query"], data["response"], data["prompt_slug"])

def log_data(context, query, response, prompt_slug):
    # Define the request body
    prompt = [
{
    "role": "system",
    "content": "Answer the following question based ONLY on the context information provided."
},
{
    "role": "user",
    "content": f"""
        ### CONTEXT:\n{context}\n
        ### QUESTION:\n{query}
    """
}]
    prompt_tokens = round(len(prompt.__str__())/4)
    completion_tokens = round(len(response)/4)
    total_tokens = prompt_tokens + completion_tokens
    response_time = random.randint(561, 1577)
    session_id = "chat_" + str(random.randint(1, 40))
    user_email = random.sample(['john@doe.com', 'vitalik@eth.org', 'tim@apple.com', 'sam@openai.com'], k=1)[0]
    # topic = random.sample(['Space', 'Science'], k=1)[0]

    data = {
        "language_model_id": random.choice(["gpt-3.5-turbo", "gpt-4-turbo-preview", "claude-2.1"]),
        "prompt": prompt,
        "response": response,
        "prompt_tokens": prompt_tokens,
        "completion_tokens": completion_tokens,
        "total_tokens": total_tokens,
        "response_time": response_time,
        "user_query": query,
        "context": context,
        "customer_id": random.choice(["usa", "ny-state", "eu-fr"]),
        "environment": "production",
        "prompt_slug": prompt_slug,
        "session_id": session_id,
        "custom_attributes": {
            "user_email": user_email
        },
        "custom_eval_metrics": {
            "dwell_time_ms": random.randint(300, 4000),
            "clicked_on_cta": random.choice([0, 1]),
            "highlighted_section": random.choice([0, 1]),
        },
    }

    # Send a POST request
    response = requests.post(url, headers=headers, json=data)

    # Check the response
    if response.status_code == 200:
        print("Log successful")
    else:
        print("Log failed: ", response.text)

if __name__ == "__main__":
    log()

"""
# Update the created_at field of the prompt_run table post that to get a random distribution of created_at dates over the last 7 days
# From prompts_db
-- Replace 'your_org_id' with the actual org_id
UPDATE prompt_run
SET created_at = NOW() - INTERVAL '1 day' * FLOOR(RANDOM() * 7)
WHERE org_id = 'your_org_id';

# Now remove the analytics data for recalculation
# From analytics_db
-- Replace 'your_org_id' with the actual org_id

-- Delete from prompt_run_analytics
DELETE FROM prompt_run_analytics
WHERE org_id = 'your_org_id'
  AND start_time >= NOW() - INTERVAL '7 days'
  AND end_time <= NOW();

-- Delete from eval_analytics
DELETE FROM eval_analytics
WHERE org_id = 'your_org_id'
  AND start_time >= NOW() - INTERVAL '7 days'
  AND end_time <= NOW();
"""