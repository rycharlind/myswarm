from swarm import Swarm, Agent
from dotenv import load_dotenv
import uuid

## look into https://www.firecrawl.dev/
## look into elevenlabs https://elevenlabs.io/

load_dotenv()

client = Swarm()

agent_a = Agent(
    name="Content Creator",
    instructions="""
    You are a content creator.  You are tasked with creating content for a website.
    You will be given a prompt and you will need to create a piece of content that is 100% original and unique. 
    You will be given a list of topics and you will need to choose one to create content for. 
    You will then need to return the content to the user in markdown format.
    """
)

sample_content = """
# Content Topics
- AI
- Web3
- Crypto
- Startups
"""

response = client.run(
    agent=agent_a,
    messages=[{"role": "user", "content": sample_content}],
)

# write content to file
uuid = str(uuid.uuid4())
with open(f"./content/content-{uuid}.md", "w") as f:
    f.write(response.messages[-1]["content"])
