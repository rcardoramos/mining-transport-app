# Seguimiento de Reglas de Embarque y Flujo de Pasajeros Externos

Este documento sirve como bitácora y guía de seguimiento para el flujo de validación y clasificación de colaboradores y pasajeros externos.

---

## 📌 Estado Actual del Requerimiento
* **Estado**: Implementado en Frontend (Maqueta/Simulación funcional).
* **Confirmación Pendiente**: Aprobación definitiva del flujo de selección por parte de Negocio / Backend.

---

## 🔄 Flujo de Trabajo Implementado

1. **Colaboradores Registrados**:
   * Son identificados automáticamente en la verificación (`checkCollaborator`).
   * Pertenecen a **Miski Mayo** por defecto (o según asigne la base de datos).
   * Se registran directamente sin interrupciones y se les asigna su respectivo badge visual en el listado.

2. **DNI / Fotocheck No Registrado (Pasajeros Externos)**:
   * Cuando se introduce un DNI que no existe en el padrón local (en el mock, DNI que inicia con `9`), la verificación retorna un error controlado (`CollaboratorNotFoundFailure`).
   * En lugar de denegar el acceso, el sistema activa una alerta interactiva para el chofer preguntándole la categoría del pasajero externo:
     * **Contratista**
     * **Terceros**
     * **Visita**
   * Tras la selección, se registra con estado `ok` y con el nombre genérico `Externo (Categoría)` para permitir su abordaje y conteo.

---

## ⚠️ Aspectos a Validar con el Backend/Negocio
* [ ] ¿Es aceptable autogenerar el nombre genérico `Externo (Categoría)` si el DNI no existe, o se requiere un campo adicional de texto para que el chofer digite manualmente el nombre/apellidos de la visita?
* [ ] ¿El backend proveerá un campo `categoria` o `empresa` estructurado en la API de verificación de colaborador para automatizar el badge visual?
* [ ] ¿Las visitas, contratistas o terceros requieren pasar por las mismas reglas de aforo o tienen alguna restricción adicional de seguridad?
