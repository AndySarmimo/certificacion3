# certificacion3

crear una carpeta en el mismo nivel que proy2/ con el nombre de:
angularFrontend/

hacer dentro de angularFrontend:
git clone https://github.com/AndySarmimo/certi3Frontend.git



#Deploy vpc
ir al directorio proy2/vpc
ejecutar:
terraform init , plan, apply

#deploy backend
ir al directorio proy2/mainPageBackend
ejecutar:
terraform init , plan, apply


#optener build
ir al directorio 
cd angularFrontend/certi3Frontend
npm install -g @angular/cli
ng build

salir del directorio hasta environment y ejecutar:
cp -R angularFrontend/certi3Frontend/dist proy2/web-hosting 

#bucket
ir al directorio proy2/web-hosting
ejecutar:
terraform init , plan, apply
