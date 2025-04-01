Steps


1. OpenSSL

Generate private key
`openssl genrsa -out private_key.pem 2048`
Generate public key
`openssl rsa -in private_key.pem -pubout -out public_key.crt`

Demo encrypt
`openssl rsautl -encrypt -inkey public_key.crt -pubin -n plain.txt -out top_secret.enc


Generate CSR
`openssl req -out CSR.csr -new -newkey rsa:2048 -keyout privatekey.key

2. Certbot

Install Certbot: Ensure you have Certbot installed on your server.
Run the Certbot command: 
`sudo certbot certonly --nginx -d yourdomain.com`