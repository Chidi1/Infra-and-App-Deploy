# Build stage
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src

# Copy all files to the build container
COPY . .

# Restore NuGet packages
RUN dotnet restore

# Run tests before publishing
RUN dotnet test

# Publish the app in Release mode to the /out folder
RUN dotnet publish -c Release -o /out

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime
WORKDIR /app

# Copy only the published output from the build stage
COPY --from=build /out .

# Expose the port the app will run on (default for ASP.NET Core is 80 or 5000)
EXPOSE 4000  

# Start the application by default
ENTRYPOINT [ "dotnet", "aspnet-core-dotnet-core.dll" ]

# Build stage
# FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
# WORKDIR /src

# # Copy all files to the build container
# COPY . .

# # Restore NuGet packages
# RUN dotnet restore

# # Publish the app in Release mode to the /out folder
# RUN dotnet publish -c Release -o /out

# # Runtime stage
# FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime
# WORKDIR /app

# # Copy only the published output from the build stage
# COPY --from=build /out .

# # Start the application by default
# ENTRYPOINT [ "dotnet", "aspnet-core-dotnet-core.dll" ]
