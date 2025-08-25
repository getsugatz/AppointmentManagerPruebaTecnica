Configuración de IIS

Paso 1: Instalar ASP.NET Core Hosting Bundle
# Descargar e instalar el Hosting Bundle desde:
# https://dotnet.microsoft.com/download/dotnet/8.0
# Buscar: "ASP.NET Core Runtime 8.0.x - Windows Hosting Bundle"

# Reiniciar IIS después de la instalación
------------------------------------------------------------------------------------------------

Paso 2: Publicar las Aplicaciones
Publicar el API y pagina en iis creando una nueva pagina asignandole la dirección donde esta alojada la api ejemplo: "C:\inetpub\wwwroot\AppointmentManagerAPI", asignarle un puerto y permisos:


Configurar Sitios en IIS
Para el API:
1. Abrir **IIS Manager**
2. Clic derecho en "Sites" > "Add Website"
3. Configurar:
   - "Site name": "AppointmentManagerAPI" puede ser el nombre que prefieran
   - "Physical path": "C:\inetpub\wwwroot\AppointmentManagerAPI"
   - "Port": "8080" el puerto puede ser uno que elijan o uno que este desocupado
4. En "Application Pools", configurar "No Managed Code" 

Para el Frontend MVC:
1. Clic derecho en "Sites" > "Add Website"
2. Configurar:
   - "Site name": "AppointmentManagerWeb"
   - "Physical path": "C:\inetpub\wwwroot\AppointmentManagerWeb"
   - "Port": "3000"
3. En "Application Pools", configurar "No Managed Code" o dejarla pro default
--------------------------------------------------------------------------------------------
Paso 3: Actualizar Configuraciones

En en la aplicacion front end esta un archivo llamado "appsettings.json" que deben cambiar la ruta del api alojada en iis:
ejemplo:
{
  "ApiSettings": {
    "BaseUrl": "http://localhost:8080/api/"
  }
}

Para la api se debe cambiar la cadena de conexion del sql server que se vaya a usar:

ejemplo:

{
  "ConnectionStrings": {
     "DbConnection": "Data Source=NEOS3//SQLSERVER;Initial Catalog=AppointmentManager;user id=prueba;password=prueba;TrustServerCertificate=True;MultipleActiveResultSets=True;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}