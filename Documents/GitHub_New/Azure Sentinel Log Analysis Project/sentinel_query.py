from azure.identity import DefaultAzureCredential
from azure.monitor.query import LogsQueryClient
from azure.monitor.query import LogsQueryStatus
from datetime import timedelta

# Replace this with your actual Log Analytics workspace ID (not name or resource group)
workspace_id = "485afc48-0b70-4c92-a83b-439fd0f7467f"

# Kusto query to run
query = "SigninLogs | take 5"

# Authenticate and initialize the client
credential = DefaultAzureCredential()
client = LogsQueryClient(credential)

# Run query
response = client.query_workspace(
    workspace_id=workspace_id,
    query=query,
    timespan=timedelta(days=1)
)

# Check result
if response.status == LogsQueryStatus.SUCCESS:
    for table in response.tables:
        print(f"\nTable: {table.name}")
        for row in table.rows:
            print(dict(zip(table.columns, row)))
else:
    print(f"Query failed with status: {response.status}")
    print(response.error)
