# Muon Detector Data Acquisition System

FPGA based DAQ for sTGC muon detector system, for muongraphy purposes.

Index:

1. [Prerrequisites](##Prerequisites)
2. [Vivado Project Rebuild](##Vivado-Project-Rebuild)
3. [Author](##Author)
4. [Supervising Professor](##Supervising-Professor)
5. [Apendix A: Version control of an HDL Vivado Project](##Appendix-A-Version-control-of-an-HDL-Vivado-Project)

## Tools and Environment

Project designed on Vivado 2019.1 under Windows 10.

The FPGA used for this design is a TRENZ TE0712-02 mounted on a TE0703-06 carrier board.

## Vivado Project Rebuild

To rebuild this project, open Vivado TCL console, and type the following lines:

```bash
cd "path_to_main_folder_of_this_repo/"
source build.tcl
```

Where 'path_to_main_folder_of_this_repo' refers to the corresponding folder path of the project, where 'build.tcl' file is. This file use or creates a folder named 'wd' (working directory) to save all generated Vivado outputs. Ensure to don't commit this folder or the files it contains.

## Author

- **Jairo González** -  jairo.gonzalez.13 [at] sansano.usm.cl

## Supervising Professor

- **Gonzalo Carvajal** - Departamento de Electrónica - Universidad Técnica Federico Santa María

----

## Appendix A: Version control of an HDL Vivado Project

A version control system, like *git*, enables the developer to maintain multiple branches, synchronize their work with others, revert changes and keep tidy versions of a project.

Using tools like these with Vivado Projects turns out to be pretty useful. In this appendix, I have summarized all tips and stages to control versions of a Vivado Project as a step-by-step tutorial. The main idea is to work just with the core files of the development, keeping outside any other file like synthesis outputs, .bit files, and others.

The tutorial makes use of "git" and a remote repository hosted on *github.com*.

Requisites:

- A github.com account.
- git installed in your machine, enabled to be operated through a terminal.
- Vivado HDL SDK (Version 2019.1 it's used in this tutorial).

### How

- **Create repo**

  Log in to a GitHub account and click the *"New"* green button to create a new repository.

  ![The *"New"* button is at the top left corner.](assets/images/new-button.gif "Location of the New button")

  Choose your repository name and configure the essentials. I recommend creating a blank project, without *readme* o *.gitignore* files. Upload them remotely on a first commit.

- **Clone repo**

  From the repository dashboard, look for the green button *"Code"* and copy the URL available for HTTPS cloning.

  ![The *"Code"* button is in the repository dashboard, in the top left near the About section.](assets/images/clone.gif "Location of the Code button")

  If you haven't installed *git* yet, go to your local machine and install it via command line o via a downloadable executable file.

  Go to the folder where you want to save your repository and open a command prompt. Type the following on it, where *your-git-url* is the URL you have previously copied:

  ```bash
  git clone your-git-url
  ```

- **Create initial files and folders**

  Go to the repository folder and create the following folders: *ip*, *src*, *wd*, and *xdc*.

  - *ip*: This folder is to include IP cores files.

  - *src*: This folder is for saving the source files of your project

  - *sim*: This folder is for saving the simulation files for testing your design

  - *xdc*: This one is to save .xdc constraints files

  - *wd*: Finally, this folder is to save synthesis, implementation outputs, and any other Vivado generated files. Don't include this folder in commits.

  Create a README.md and a .gitinit file. The readme file is relevant for explaining your repo content.  You should write it in Markdown language.

For the .gitinit, include any system-created file to don't upload it to git, and add the following lines to don't upload files and folders generated from Vivado:

  ```txt
  wd/
  .Xil/
  ```

- **Prepare project**

  Create your project, as usual, saving it into de "wd". If you have already created it on another folder, move it to "wd".
  
  Copy or create your src files on the "src" folder on the repo.  Do the same with simulation files, constraints files to their respective folders on the repo.

  If you use IP cores, ensure that you have enabled the option of IP Core containers. It creates an IP Core out of a single *.xcix* file, which is useful to version control purposes. If Vivado asks you to convert your IP cores to containers, click on *Ok*. Then move your single IP Cores files to the respective "IP" folder in the repo.

  ![The IP Containers option is under "Tools>Settings>Project Settings>IP>Core Containers: Use Core Containers for IP".](assets/images/containers.gif "Configuring Vivado to use IP Containers")

  Finally, replace the files listed on the "Source" section of Vivado with the files saved on your repository.

- **Export Tcl**

  Export a Tcl file of the project from the Vivado GUI menu. Save it on your main repo directory and name it *build.tcl*. Keep in mind that you may need to do this every time you add or remove a file on the Vivado project. It is ok to don't do it, but you will need to import and delete files manually when rebuilt.

  ![The "Write Tcl" option is under "File>Project>Write Tcl".](assets/images/tcl.gif "Writing a Tcl building file")

- **Edit Tcl**

  Edit your Tcl file to rebuild the project just inside "wd" folder. To do this, search the following three commands:

  ```Tcl
  # Set the reference directory for source file relative paths (by default the value is script directory path)
  set origin_dir "."
  ```
  
  ```Tcl
  # Set the directory path for the original project from where this script was exported
  set orig_proj_dir "path-to-the-actual-vivado-project"

  # Create project
  create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part part-of-your-fpga
  ```

  And replace them with the following lines respectively:

  ```Tcl
  # Set the reference directory for source file relative paths (by default the value is script directory path)
  set origin_dir [file dirname [info script]]
  ```

  ```Tcl
  # Set the directory path for the original project from where this script was exported
  set orig_proj_dir "[file normalize "$origin_dir/wd/"]"

  # Create project
  create_project ${_xil_proj_name_} $orig_proj_dir/${_xil_proj_name_} -part part-of-your-fpga
  ```

- **Commit and push**

  At this point, everything is ready to do the first commit and start controlling your project versions.
  Commit your work and push it with the following commands. Ensure you have correctly configured your ".gitignore" file before committing! Review your folders and lookup for any hidden file to ignore them explicitly.

  When done, commit:

  ```bash
  git add .
  git commit -m "First commit."
  git push
  ```

   And that's all!

- **Delete older Vivado project folder**
  
  Now you can freely delete your older Vivado project folder because you can rebuild it again running your new *build.tcl* script as indicated in [Vivado Project Rebuild](##Vivado-Project-Rebuild) section.

### References

1. [J. Johnson, "Version Control for Vivado Projects", www.fpgadeveloper.com, 2014](http://www.fpgadeveloper.com/2014/08/version-control-for-vivado-projects.html)

2. [Xilinx,"Vivado Revision Control Tutorial - UG1198 (v2015.4)", 2015](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2015_4/ug1198-vivado-revision-control-tutorial.pdf)

3. [Xilinx, "Using Source Control Systems With The Vivado Tool - UG892 (v2018.2)", Chapter 5, 2018](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_2/ug892-vivado-design-flows-overview.pdf#nameddest=xUsingSourceControlSystemsWithTheVivadoTool)

----
