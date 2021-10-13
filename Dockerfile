FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ConversaoPeso.Web/ConversaoPeso.Web.csproj", "ConversaoPeso.Web/"]
RUN dotnet restore "ConversaoPeso.Web/ConversaoPeso.Web.csproj"
COPY . .
WORKDIR "/src/ConversaoPeso.Web"
RUN dotnet build "ConversaoPeso.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ConversaoPeso.Web.csproj" -c Release -o /app/publish

FROM base As final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT [ "dotnet", "ConversaoPeso.Web.dll" ]

#
# VERSÃO 1 ABAIXO
#

# # https://hub.docker.com/_/microsoft-dotnet
# FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
# WORKDIR /source

# # copy csproj and restore as distinct layers
# COPY *.sln .
# COPY ConversaoPeso.Web/*.csproj ./ConversaoPeso.Web/
# RUN dotnet restore

# # copy everything else and build app
# COPY ConversaoPeso.Web/. ./ConversaoPeso.Web/
# WORKDIR /source/ConversaoPeso.Web
# RUN dotnet publish -c release -o /app --no-restore

# # final stage/image
# FROM mcr.microsoft.com/dotnet/aspnet:5.0
# WORKDIR /app
# COPY --from=build /app ./
# ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]