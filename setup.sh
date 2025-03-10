#!/bin/bash

# Ensure the script is run as a user with sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo."
   exit 1
fi

# Update system package list and install dependencies
echo "Updating system packages and installing dependencies..."
sudo apt update && sudo apt install -y openjdk-21-jdk wget

# Download BuildTools.jar from Spigot's Jenkins
echo "Downloading BuildTools.jar..."
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

# Run BuildTools to build Spigot
echo "Building Spigot server using BuildTools..."
java -jar BuildTools.jar

# Clean up BuildTools.jar after the build
echo "Cleaning up BuildTools.jar..."
rm BuildTools.jar

# Output the public IP address of the machine
echo "Your public IP is: $(curl -s http://ipinfo.io/ip)"
echo "Minecraft will be hosted on default port (25565)"
echo "If you plan on playing with others, make sure to set up port forwarding on your router. "

# Create the spigot-start command for future use
echo "Creating spigot-start command..."
cat <<EOF > /usr/local/bin/spigot-start
#!/bin/bash
cd /$(pwd) && java -Xms1G -Xmx1G -jar spigot-*.jar
EOF

# Make the spigot-start script executable
chmod +x /usr/local/bin/spigot-start

# Notify the user
echo "spigot-start command has been created. You can now use it to start the server in the future."

# Run the Spigot server
echo "Starting Spigot server..."
java -Xms1G -Xmx1G -jar spigot-*.jar
