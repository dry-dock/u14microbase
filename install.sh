#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

echo "================ Installing locales ======================="
dpkg-divert --local --rename --add /sbin/initctl
locale-gen en_US en_US.UTF-8 && \
dpkg-reconfigure locales

echo "HOME=$HOME"
cd /u14

echo "================= Updating package lists ==================="
apt-get update

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p "$HOME/.ssh/"
mv config "$HOME/.ssh/"
mv 90forceyes /etc/apt/apt.conf.d/
touch "$HOME/.ssh/known_hosts"
mkdir -p /etc/drydock

echo "================= Installing basic packages ==================="
apt-get install -q -y \
  build-essential=12.1* \
  curl=7.47.0* \
  gcc=4:5.3.1* \
  gettext=0.19.7* \
  htop=2.0.1* \
  libxml2-dev=2.9.3* \
  libxslt1-dev=1.1.28* \
  make=4.1* \
  nano=2.5.3* \
  openssh-client=1:7.2p2* \
  openssl=1.0.2g* \
  software-properties-common=0.96.20.7 \
  sudo=1.8.16*  \
  texinfo=6.1.0* \
  unzip=6.0-20ubuntu1 \
  wget=1.17.1* \
  rsync=3.1.1* \
  psmisc=22.21* \
  vim=2:7.4.1689*

echo "================= Installing Python packages ==================="
apt-get install -q -y \
  python-pip=8.1.1* \
  python-software-properties=0.96.20* \
  python-dev=2.7.12*

pip install -q virtualenv==15.1.0
pip install -q pyOpenSSL==16.2.0

echo "================= Installing Git ==================="
add-apt-repository ppa:git-core/ppa -y
apt-get update
apt-get install -q -y git=1:2.16.2*

echo "================= Adding JQ 1.5.1 ==================="
apt-get install -q jq=1.5*

echo "================= Installing Node 7.x ==================="
. /u14/node/install.sh

echo "================= Adding gcloud ============"
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get update && sudo apt-get install -q google-cloud-sdk=173.0.0-0

KUBECTL_VERSION=1.8.0
echo "================= Adding kubectl $KUBECTL_VERSION ==================="
curl -sSLO https://storage.googleapis.com/kubernetes-release/release/v"$KUBECTL_VERSION"/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

AZURE_CLI_VERSION=2.0.25*
echo "================ Adding azure-cli $AZURE_CLI_VERSION =============="
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
  sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
sudo apt-get install -q apt-transport-https=1.2.25
sudo apt-get update && sudo apt-get install -q -y azure-cli=$AZURE_CLI_VERSION

echo "================= Intalling Shippable CLIs ================="

git clone https://github.com/Shippable/node.git nodeRepo
./nodeRepo/shipctl/x86_64/Ubuntu_14.04/install.sh
rm -rf nodeRepo

echo "Installed Shippable CLIs successfully"
echo "-------------------------------------"

rm -rf /usr/local/lib/python2.7/dist-packages/requests*
pip install --upgrade pip

echo "================== Installing python requirements ====="
pip install -r /u14/requirements.txt

echo "================= Cleaning package lists ==================="
hash -r
apt-get clean
apt-get autoclean
apt-get autoremove
