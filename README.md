## Nexus server configuration

This nexus server build introduces a couple of new concepts.

* AWS User data
* Dual build (packer + vagrant-aws)

----

### AWS User data

User data definitions are located in `./aws/src/` and the extension of the file implies the type for the mime type.
e.g. `setup1.cloud-config` implies the file type is cloud-config (more examples about different types of cloud-init files can be found [in the cloud-init src repo](http://bazaar.launchpad.net/~cloud-init-dev/cloud-init/trunk/files/head:/doc/examples/))

### Dual build (packer + vagrant-aws)

1. set your AWS credentials as ENV vars named AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
2. do `vagrant plugin install vagrant-aws && vagrant up` to provision nexus on aws
3. do `./create-ami.sh` to execute packer and create an ami.
