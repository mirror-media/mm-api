# mm-api
for the apiv2

## Development

### Up and Running

To run the server:

 1. Install dependencies: `mix deps.get`
 2. Start Phoenix server: `mix phoenix.server`

### Request with CURL

**Create**
```bash
curl -i -H "Content-Type:application/json" -d '{"name":"Name"}' http://localhost:8080/bq"
``` 