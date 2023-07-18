<h1 align="center">
  🐘🎯 Hexagonal Architecture, DDD & CQRS in PHP
</h1>

<p align="center">
    <a href="https://symfony.com/"><img src="https://img.shields.io/badge/Symfony-6-42a7ff.svg?style=flat-square&logo=symfony" alt="Symfony 6"/></a>
    <a href="https://www.php.net/"><img src="https://img.shields.io/badge/PHP-8.2-777BB4.svg?style=flat-square&logo=php" alt="PHP"/></a>
    <a href="https://www.docker.com/"><img src="https://img.shields.io/badge/docker-20.10-2496ED.svg?style=flat-square&logo=docker" alt="Docker"/></a>
</p>

<p align="center">
  Mono repository with multiple applications using Domain-Driven Design (DDD) and Command Query Responsibility Segregation
  (CQRS) principles</strong>.
  <br />
  <br />
</p>

### 📓 Engineering Wiki

* [🚜 Getting Started](doc/getting_started.md)
* [🤖 Engineering Guidelines](doc/engineering_guidelines.md)
    * [📚 ADR](doc/adr.md)
    * [👾 Create Bounded Context / Module](doc/create_context_module.md)
    * [Code Style](doc/code_style.md)
    * [📗 Collections](doc/collections.md)
    * [Application services](doc/application_service.md)
    * [Responses](doc/responses.md)
    * [Domain services](doc/domain_service.md)
    * [🧪 How to write a test](doc/how_to_write_test.md)
    * [💑 Pair programming](doc/pairing_guidelines.md)
    * [🛎 Support ](doc/support.md)
    * [✨ Git Flow ](doc/git_flow.md)
* [🔄 Development Lifecycle](doc/development_lifecycle.md)
* [🚢 How to Deploy](doc/how_to_deploy.md)
* [⚒️ Useful Commands](doc/useful_commands.md)
* [📖 Engineering Interviews](doc/engineering_interviews.md)
* [📝 How to QA](doc/how_to_qa.md)
* [✅ Code Reviews](doc/code_reviews.md)
* [💎 Bounded Context](doc/bounded-context.md)
* [🕸️ AWS](doc/aws.md)

### 🛠️ Infrastructure Diagram

A visual representation of the Ecosystem infrastructure can be found in the "diagrams" directory of this repository. Here is a preview:

![Ecosystem Infrastructure Diagram](diagrams/ecosystem-infra.png)

### Updating the Infrastructure Diagram

In the event of any modifications to the Ecosystem infrastructure diagram, it is crucial to update it to reflect the changes accurately. To update the diagram execute the following command: ``make update-diagram ``
