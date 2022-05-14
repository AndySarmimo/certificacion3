# Proyecto certificacion3

arn snapshot base de datos -> arn:aws:rds:us-east-1:271878697119:snapshot:flashsnapshotv2    <br />
id imagen de backend:   ami-0dbbb837b1373416b    <br />

### Porsia caso el git de backend:  <br />
https://github.com/AndySarmimo/certi3backend.git  



## Empezar con el despliegue de terraform
### copiar repositorio frontend 
1. crear una carpeta en el mismo nivel que proy2/ con el nombre de:  <br />
angularFrontend/

2. hacer dentro de angularFrontend:  <br />
git clone https://github.com/AndySarmimo/certi3Frontend.git



### Deploy vpc
3. ir al directorio proy2/vpc  <br />
ejecutar:
terraform init , plan, apply

### deploy backend
4. ir al directorio proy2/mainPageBackend <br />
ejecutar:
terraform init , plan, apply
<br />
se tiene despues el proxy.conf.js  adecuado para conectar al loadbalancer desde el frontend
<br />
al acabar etapa se debe ir a obtene el build <br />
5. ir al directorio  <br />
cd angularFrontend/certi3Frontend <br />
npm install -g @angular/cli <br />
ng build <br />

6. salir del directorio hasta environment y ejecutar: <br />
cp -R angularFrontend/certi3Frontend/dist proy2/web-hosting  <br />

### bucket
7. ir al directorio proy2/web-hosting <br />
ejecutar:
terraform init , plan, apply
