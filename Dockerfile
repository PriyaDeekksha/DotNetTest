FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["DotNetTest.csproj", "."]
RUN dotnet restore "./DotNetTest.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DotNetTest.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "DotNetTest.csproj" -c Release -o /app/publish
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetTest.dll"]