from swarm import Swarm, Agent
from dotenv import load_dotenv
import uuid
from topics import get_topic
from search import search_google

# look into https://www.firecrawl.dev/
# look into elevenlabs https://elevenlabs.io/

load_dotenv()

client = Swarm()

def search_web(query: str):
    return search_google(query)


agent_content_creator = Agent(
    name="Content Creator",
    instructions="""
    You are a content creator.  You are tasked with creating content for a website.
    You will be given a prompt and you will need to create a piece of content that is 100% original and unique. 
    You will be given a list of topics and you will need to choose one to create content for. 
    You will then need to return the content to the user in markdown format.
    """
)

agent_search_web = Agent(
    name="Search Web Agent",
    instructions="""
    You are a helpful agent. 
    You are tasked with searching the web for information.
    You will be given a query and you will need to search the web for information.
    You will then need to return the results and transfer control to the next agent.
    """,
    functions=[search_web],
    agents=[agent_content_creator]
)

agent_start = Agent(
    name="Start Swarm Agent",
    instructions="""
    You are a helpful agent. 
    You are tasked with starting a swarm.
    You will be given a query and you will need to start a swarm to search the web for information.
    You will then need to return the results and transfer control to the next agent.
    """,
    agents=[agent_search_web],
)

def write_content_to_file(content: str):
    id = str(uuid.uuid4())
    with open(f"./content/content-{id}.md", "w") as f:
        f.write(content)

if __name__ == "__main__":
    topic = get_topic()
    print(f"Starting swarm to research the topic: {topic}")
    response = client.run(
        agent=agent_start,
        messages=[{"role": "user", "content": f"Start a swarm to research the topic: {topic}"}]
    )
    write_content_to_file(response.messages[-1]["content"])
    # print(response)

