# mm-api
for the apiv2

## Development

### Up and Running

To run the server:

 1. Install dependencies and compile: 
 ```
 mix do deps.get, compile 
 ```
 2. Run the server:  

   * With developing settings:  

 ```
 mix phoenix.server
 ```  

   * With production settings:  
      To view the effect for every change you made in production mode, you have to be compiled explicitly.  
 

 ```
 MIX_ENV=prod mix compile
 MIX_ENV=prod mix phoenix.server
 ```

### Test with cURL request

*Get Content*
```
curl -i http://localhost:8080/bq
```

*Create*
```bash
curl -i -H "Content-Type:application/json" -d '{"name":"Name"}' http://localhost:8080/bq"
``` 
