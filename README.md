[![Research Software Directory](https://img.shields.io/badge/rsd-Research%20Software%20Directory-00a3e3.svg)](https://www.research-software.nl/software/research-software-directory)
[![Build Status](https://travis-ci.org/research-software-directory/research-software-directory.svg?branch=master)](https://travis-ci.org/research-software-directory/research-software-directory)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1154130.svg)](https://doi.org/10.5281/zenodo.1154130)

This README file has the following sections:


- [What is the Research Software Directory?](#what-is-the-research-software-directory)
- [How do I enter data into an instance of the Research Software Directory?](#how-do-i-enter-data-into-an-instance-of-the-research-software-directory)
- [Documentation for developers](#documentation-for-developers)
    - [Try it out locally](#try-it-out-locally)
    - [Customize your instance of the Research Software Directory](#customize-your-instance-of-the-research-software-directory)
    - [Make your instance available to others by hosting it online (deployment)](#make-your-instance-available-to-others-by-hosting-it-online-deployment)
- [Documentation for maintainers](#documentation-for-maintainers)


# What is the Research Software Directory?

The Research Software Directory is a content management system that is tailored
to software.

The idea is that institutes for whom research software is an important output,
can run their own instance of the Research Software Directory. The system is
designed to be flexible enough to allow for different data sources, database
schemas, and so on. By default, the Research Software Directory is set up to
collect data from GitHub, Zenodo, Zotero, as well as Medium blogs.

For each software package, a _product page_ can be created on the Research
Software Directory if the software is deemed useful to others. Here is an
example of what a product page may look like:

![/docs/images/20180627-webcapture-xenon.png](/docs/images/20180627-webcapture-xenon.png)

While the content
shown on the product page can be completely customized, by default it includes a
_Mentions_ section, which can be used to characterize the context in which the
software exists. The context may include links to scientific papers, but is
certainly broader than that: for example, there may be links to web applications
that demonstrate the use of the software, there may be links to videos on
YouTube, tutorials on readthedocs.io or Jupyter notebooks, or there may be links
to blog posts; really, anything that helps visitors decide if the software could
be useful for them.

The Research Software Directory improves findability of software packages,
partly because it provides metadata that helps search engines understand what
the software is about, but more importantly because of the human centered text
snippets that must be provided for each software package. After all, discovery
of a software package is often not so much about finding it but knowing that you
found it.

# How do I enter data into an instance of the Research Software Directory?

The process is described [here](/docs/instruction/README.md).

# Documentation for developers

## Try it out locally

Basically, the steps to get a copy of https://research-software.nl running locally (including data) are as follows:

1. Fork this repo to your own GitHub organization or GitHub profile and clone it
1. Configure
1. Start the complete stack using ``docker-compose``

For details, see below.

Make sure you have a Linux computer with ``docker``, ``docker-compose``, and
``git`` installed. Other operating systems might work but we develop exclusively
on Linux based systems. You can find the installation instructions for each tool
here:
- ``docker``: https://docs.docker.com/install/
- ``docker-compose``: https://docs.docker.com/compose/install/
- ``git``: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

You'll need a minimum of about 3 GB free disk space to 
store the images, containers and volumes that we will be making. 

Optionally, add yourself to the ``docker`` group following the instructions
[here](https://docs.docker.com/install/linux/linux-postinstall/) (our
documentation assumes that you did).

### Try it out, step 1/3: Fork and clone

Click the ``Fork`` button on
https://github.com/research-software-directory/research-software-directory/ to
fork to your own GitHub organization or GitHub profile, then:

```bash
git clone https://github.com/research-software-directory/research-software-directory.git
```

### Try it out, step 2/3: Configure

The research software directory is configured using a file with environment
variables called `rsd-secrets.env`. An example config file
(`rsd-secrets.env.example`) is available, use it as a starting point.

```bash
cd research-software-directory
cp rsd-secrets.env.example rsd-secrets.env
```

The config file has some placeholder values (`changeme`); they must be set by
editing the `rsd-secrets.env` file. Below are instructions on how to get the
different tokens and keys.

#### ``AUTH_GITHUB_CLIENT_ID`` and ``AUTH_GITHUB_CLIENT_SECRET``

These environment variables are used for authenticating a user, such that they
can be granted access to the admin interface to create, read, update, and delete
items in the Research Software Directory.

These are the steps to assign values: 

1. Go to https://github.com/settings/developers
1. Click the ``New OAuth App`` button
1. Under ``Application name``, write something like _The Research Software
Directory's admin interface on localhost_
1. Under ``Homepage URL`` fill in some URL, for example, let it point to this
readme on GitHub. Despite the fact that it is a required field, its value is
not used as far as I can tell.
1. Optionally add a description. This is especially useful if you have multiple OAuth apps
1. The most important setting is the value for ``Authorization callback url``.
Set it to http://localhost/auth/get_jwt for now. We will revisit
``AUTH_GITHUB_CLIENT_ID`` and ``AUTH_GITHUB_CLIENT_SECRET`` in the section about
deployment
[below](#make-your-instance-available-to-others-by-hosting-it-online-deployment))
1. Click ``Register application``
1. Assign the ``Client ID`` as value for ``AUTH_GITHUB_CLIENT_ID`` and assign
the ``Client Secret`` as value for ``AUTH_GITHUB_CLIENT_SECRET``

#### ``AUTH_GITHUB_ORGANIZATION`` 

Data is entered into the Research Software Directory via the admin interface.
Set ``AUTH_GITHUB_ORGANIZATION`` to the name of the GitHub organization whose
members should be allowed access to the admin interface. Most likely, it is the
name of the organization where you forked this repository to.

Note: members should make their membership of the GitHub organization public. Go
to
[https://github.com/orgs/&lt;your-github-organization&gt;/people](https://github.com/orgs/your-github-organization/people)
to see which users are a member of &lt;your-github-organization&gt;, and whether
their membership is public or not. 

#### ``GITHUB_ACCESS_TOKEN``

To query GitHub's API programmatically, we need an access token. Here's how you can get one:

1. Go to https://github.com/settings/tokens
1. Click ``Generate new token``
1. Under ``Token description``, fill in something like _Key to programmatically retrieve information from GitHub's API_
1. Verify that all scopes are unchecked
1. Use token as value for ``GITHUB_ACCESS_TOKEN``

#### ``ZOTERO_LIBRARY``

When getting the references data from Zotero, this environment variable
determines which library on Zotero is going to be harvested. Go to
https://www.zotero.org/groups/ to see which Zotero groups you are a member of.
If you click on the ``Group library`` link there, the URL will change to
something like
https://www.zotero.org/groups/1689348/netherlands_escience_center/items, where
``1689348`` is the value you need to assign to ``ZOTERO_LIBRARY``.


#### ``ZOTERO_API_KEY``

To query Zotero's API programmatically, we need an API key. Here's how
you can get one:

1. https://www.zotero.org/settings/keys
1. Click ``Create new private key``
1. Type a description of the key, e.g. _API key to access library X on Zotero_
1. Under ``Personal library``, make sure only ``Allow library access`` is checked. 
1. Under ``Default group permissions``, choose ``None``
1. Under ``Specific groups``, check ``Per group permissions``
1. Set ``Read only`` for the group that you want to harvest your references data from; verify that any other groups are set to ``None``
1. Click the ``Save Key`` button at the bottom of the page. 
1. On the ``Key Created`` page, you will see a string of random character,
something like ``bhCJSBCcjzptBvd3fvliYOoE``. This is the key; assign it to
``ZOTERO_API_KEY``

#### ``BACKUP_CMD``

This environment variable is used for making a daily backup of the database with
software, people, projects, etc. As it is typically only used during deployment,
leave its value like it is for now; we will revisit it in the section about
deployment
[below](#make-your-instance-available-to-others-by-hosting-it-online-deployment)).


#### ``JWT_SECRET``

<!-- This environment variable is used for ... TODO -->

The ``JWT_SECRET`` is simply a string of random characters. You can generate one
yourself using the ``openssl`` command line tool, as follows:

```bash
openssl rand -base64 32
```

Assign the result to ``JWT_SECRET``.


### Try it out, step 3/3: Start the complete stack using [docker-compose](https://docs.docker.com/compose/)

```bash
# add the environment variables from rsd-secrets.env to the current terminal:
source rsd-secrets.env

# start the full stack using docker-compose:
docker-compose --project-name rsd up --build
# shorthand:
docker-compose -p rsd up --build
```

After the Research Software Directory instance is up and running, we want to
start harvesting data from external sources such as GitHub, Zotero, Zenodo, etc.
To do so, open a new terminal and run

```bash
docker-compose --project-name rsd exec harvesting python app.py harvest all
```

You should see some feedback in the newly opened terminal. 

After the ``harvest all`` task finishes, several database collections should
have been updated, but we still need to use the data from those separate
collections and combine them into one document that we can feed to the frontend.
This is done with the ``resolve`` task, as follows:

```bash
docker-compose --project-name rsd exec harvesting python app.py resolve
```

By default, the ``resolve`` tasks runs every fifth minute anyway, so you could just wait for a bit, until you see some output scroll by that is generated by the ``rsd-harvesting`` container, something like:

```
rsd-harvesting     | 2018-07-11 10:30:02,990 cache_software [INFO] processing Xenon command line interface
rsd-harvesting     | 2018-07-11 10:30:03,013 cache_software [INFO] processing Xenon gRPC server
rsd-harvesting     | 2018-07-11 10:30:03,036 cache_software [INFO] processing xtas
rsd-harvesting     | 2018-07-11 10:30:03,059 cache_software [INFO] processing boatswain
rsd-harvesting     | 2018-07-11 10:30:03,080 cache_software [INFO] processing Research Software Directory
rsd-harvesting     | 2018-07-11 10:30:03,122 cache_software [INFO] processing cffconvert
rsd-harvesting     | 2018-07-11 10:30:03,149 cache_software [INFO] processing sv-callers

```

Open a web browser to verify that everything works as it should.

- [``http://localhost``](http://localhost) should show a local instance of the Research Software Directory
- [``http://localhost/admin``](http://localhost/admin) should show the Admin interface to the local instance of the Research Software Directory
- [``http://localhost/api/software``](http://localhost/api/software) should show a JSON representation of all software in the local instance of the Research Software Directory
- [``http://localhost/software/xenon``](http://localhost/software/xenon) should show a product page (here: Xenon) in the local instance of the Research Software Directory
- [``http://localhost/api/software/xenon``](http://localhost/api/software/xenon) should show a JSON representation of a product (here: Xenon) in the local instance of the Research Software Directory
- [``http://localhost/graphs``](http://localhost/graphs) should show you some integrated statistics of all the packages in the local instance of the Research Software Directory
- [``http://localhost/oai-pmh?verb=ListRecords&metadataPrefix=datacite4``](http://localhost/oai-pmh?verb=ListRecords&metadataPrefix=datacite4) should return an XML document with metadata about all the packages that are in the local instance of the Research Software Directory, in DataCite 4 format. 
---

## Customize your instance of the Research Software Directory

### General workflow when making changes

Let's say you followed the steps above, and have a running instance of the
Research Software Directory. Now you may want to make some changes to bring the
frontend in line with your institute's branding. For example, you could follow
the steps outlined [here](docs/faq/how-do-i-change-the-font.md) to change the fonts.

Now the question is, after making your changes, how do you get to see them?
Here's how:

1. Go to the terminal where you started ``docker-compose``
1. Use Ctrl+C to stop the running instance of Research Software Directory
1. Check which docker containers you have with:

    ```
    docker-compose --project-name rsd ps
    # shorthand:
    docker-compose -p rsd ps
    ```

    For example, mine says:

    ```
    docker-compose -p rsd ps
           Name                     Command                State     Ports 
    ----------------------------------------------------------------------
    rsd-admin            sh -c rm -rf /build/* && c ...   Exit 0           
    rsd-authentication   /bin/sh -c gunicorn --prel ...   Exit 0           
    rsd-backend          /bin/sh -c gunicorn --prel ...   Exit 0           
    rsd-database         /mongo.sh --bind_ip 0.0.0.0      Exit 137         
    rsd-frontend         /bin/sh -c sh -c "mkdir -p ...   Exit 0           
    rsd-nginx-ssl        /bin/sh -c /start.sh             Exit 137         
    rsd-reverse-proxy    /bin/sh -c nginx -g 'daemo ...   Exit 137         
    rsd-harvesting       /bin/sh -c crond -d7 -f          Exit 137  
    ```

    Use ``docker-compose rm`` to delete container by their **service name**, e.g. the ``rsd-frontend`` container:

    ```
    docker-compose --project-name rsd rm frontend
    # shorthand: 
    docker-compose -p rsd rm frontend
    ```

    List all docker images on your system:
    ```
    docker images
    ```
    
    Note that image names consist of whatever you entered as **--project-name**, followed by ``_``,
    followed by the service name. Remove as follows:

    ```
    docker rmi rsd_frontend
    ```
1. Make changes to the source code of the service whose container and image you just removed
1. Rebuild containers as necessary, using:

    ```
    docker-compose --project-name rsd build frontend
    docker-compose --project-name rsd up frontend
    ```

### Frequently Asked Questions

Refer to the Frequently Asked Questions for more detailed
answers to specific questions:

#### Frontend

1. [How do I change the font?](docs/faq/how-do-i-change-the-font.md)
1. [How do I change the logo?](docs/faq/how-do-i-change-the-logo.md)
1. [How do I change the colors?](docs/faq/how-do-i-change-the-colors.md)

#### Harvesting

1. [How do I change when data collection scripts run?](docs/faq/how-do-i-change-when-data-collection-scripts-run.md)



## Make your instance available to others by hosting it online (deployment)

TODO

### Making a backup to Amazon's S3 storage using Xenon

The backup service contains a program that can copy to a range of storage providers. We use it to make backups of the MongoDB database every day, which we store on Amazon's S3. For this, we configured the environmental variable ``BACKUP_CMD`` as follows (see explanation below):

```
BACKUP_CMD="xenon filesystem s3 \
--location http://s3-us-west-2.amazonaws.com/nyor-yiwy-fepm-dind/ \
--username AKIAJ52LWSUUKATRQZ2A \
--password xQ3ezZLKN7XcxIwRko2xkKhV9gdJ5etA4OyLbXN/ \
upload rsd-backup.tar.gz /rsd-backups/nlesc/rsd-backup-$(date --utc -Idate).tar.gz"
```

- The bucket name is ``nyor-yiwy-fepm-dind``. It is physically located in zone ``us-west-2``.
- We access the bucket using a limited-privileges IAM user, for which we created an access key (which has been deactivated since)
    - Access key ID is ``AKIAJ52LWSUUKATRQZ2A``
    - Secret access key is ``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``
- ``rsd-backup.tar.gz`` is the name of the backup archive as it is called inside the container; ``/rsd-backups/nlesc/rsd-backup-$(date --utc -Idate).tar.gz`` is the path inside the bucket. It includes the date to avoid overwriting previously existing archives.

# Documentation for maintainers

## Visualizing ``docker-compose.yml``

It is sometimes helpful to visualize the structure in the ``docker-compose.yml`` file.
Use https://github.com/pmsipilot/docker-compose-viz to generate a png image.

```
docker run --rm -it --name dcv -v $(pwd):/input pmsipilot/docker-compose-viz render -m image --output-file=docs/images/docker-compose.png docker-compose.yml
```

For example,

![/docs/images/docker-compose.png](/docs/images/docker-compose.png)

## Making a release

1. Write the release notes
1. Update CITATION.cff
1. Generate the metadata file for Zenodo using [cffconvert](https://pypi.org/project/cffconvert/).

    ```bash
    pip install --user cffconvert
    cffconvert --outputformat zenodo --ignore-suspect-keys --outfile .zenodo.json
    ```
    ```bash
    # git add, commit, and push everything
    ```

1. Make sure that everything is pushed

    ```bash
    cd $(mktemp -d)
    git clone https://github.com/research-software-directory/research-software-directory.git
    cd research-software-directory
    ```

1. Follow the notes from the ['For developers'](#documentation-for-developers) section above, and verify that it all works as it should.
1. Use GitHub's ``Draft a new release`` button [here](https://github.com/research-software-directory/research-software-directory/releases) to make a release.



