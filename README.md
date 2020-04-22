# Protogen sample project

The main goal of this project is to provide a **reference model** of how to write **maintainable Ansible code**. That includes collections, playbooks, roles, modules, plugins and filters.

By maintainable it means fully testable on **CI/CD pipelines or locally** using the most appropriate testing method like linting, unit, functional, integration.

The project will use the most appropriate test isolation solution for each testing stage: tox for unittests, containers for code that can be tested using a container and, as a last resort, VMs run localy using libvirt or remotely on a cloud.

The project goal is to become a living template or **reference implementation** that can be used by developers for creating new Ansible content or for adopting good practices.

This project will make use of popular testing tools like: [pytest](https://github.com/pytest-dev/pytest), [ansible-lint](https://github.com/ansible/ansible-lint), [molecule](https://github.com/ansible-community/molecule) in order to achieve its goals.

If possible, we would be pleased if this project would become part  of the official Ansible development documentation, which at this point does  not cover some essential cases like: how to write and run unittests for a module inside your collection.

# Joining this community effort

If you have an interest about promoting good coding standards, feel free to [join
our group](https://github.com/ansible-community/protogen/issues/1). Even if you do not
have time to propose new changes, your help as a reviewer would be essential in
order to assure we adopt only the best practices.

# History

The idea to name the project [Protogen](https://expanse.fandom.com/wiki/Protogen) came from the company behind viral protomolecule from [Expanse TV series](https://en.wikipedia.org/wiki/The_Expanse_(TV_series)). Originally, @ssbarnea considered using protomolecule as name of the project because it was aimting to create a prototype example of molecule use.

Even the original slogan **"First. Fastest. Furthest"** does apply very well with the **testing** goal of the project. Mainly the project aims to create a set of testing practices that could get a viral adoption among Ansible universe.

![protogen-logo](https://repository-images.githubusercontent.com/257321711/e95a5600-832d-11ea-8e55-a81114b6c965)
