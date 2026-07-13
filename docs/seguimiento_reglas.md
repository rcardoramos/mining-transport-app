# Seguimiento de Reglas de Embarque y Flujo de Pasajeros Externos

Este documento sirve como bitácora y guía de seguimiento para el flujo de validación y clasificación de colaboradores y pasajeros externos.

---

## 📌 Estado Actual del Requerimiento
* **Estado**: Implementado e Integrado (Identificación Automática).
* **Confirmación**: Backend provee la categoría (`Miski Mayo`, `Contratista`, `Terceros`, `Visita`) y el estado directamente en la respuesta del servicio de verificación (`checkCollaborator`).

---

## 🔄 Flujo de Trabajo Implementado

1. **Identificación Automática (Colaboradores y Externos)**:
   * Todos los pasajeros (colaboradores directos o personal contratista, terceros y visitas registradas) son validados por medio de `checkCollaborator` usando su DNI o escaneo de Fotocheck/QR.
   * El servicio del backend responde con la información completa: nombre, estado de excepción laboral y la categoría correspondiente.
   * La aplicación mapea esta categoría de manera automática (`collaborator.category`) y realiza el abordaje sin interrupciones ni cuadros de diálogo de selección interactivos.
   * En la UI del manifiesto se le asigna de inmediato su respectivo badge visual según la categoría resuelta (`Miski Mayo`, `Contratista`, `Terceros`, `Visita`).

2. **DNI No Registrado en el Padrón (No Encontrado)**:
   * Si el DNI consultado no existe de ninguna forma en el padrón del sistema (el check retorna `CollaboratorNotFoundFailure`), se despliega una alerta informativa que deniega el abordaje por no estar registrado en el padrón.

---

## ⚠️ Aspectos Validados con el Backend/Negocio
* [x] **¿El backend proveerá la categoría?** Sí, el servicio de verificación retorna el campo `category` estructurado, lo cual elimina la necesidad de que el conductor seleccione la categoría manualmente en el terminal.
* [x] **¿Se requiere ingreso manual de nombres?** No, el padrón del backend provee los datos de registro (incluso para visitas o contratistas enrolados previamente). Si un DNI no está en el sistema, su acceso es denegado de forma predeterminada.
