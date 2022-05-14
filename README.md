# certificacion3

crear una carpeta en el mismo nivel que proy2/ con el nombre de:
angularFrontend/

hacer dentro de angularFrontend:
git clone https://github.com/AndySarmimo/certi3Frontend.git



#Deploy vpc
ir al directorio proy2/vpc  <br />
ejecutar:
terraform init , plan, apply

#deploy backend
ir al directorio proy2/mainPageBackend <br />
ejecutar:
terraform init , plan, apply


#optener build
ir al directorio  <br />
cd angularFrontend/certi3Frontend <br />
npm install -g @angular/cli <br />
ng build <br />

salir del directorio hasta environment y ejecutar: <br />
cp -R angularFrontend/certi3Frontend/dist proy2/web-hosting  <br />

#bucket
ir al directorio proy2/web-hosting <br />
ejecutar:
terraform init , plan, apply
