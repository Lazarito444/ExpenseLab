---
trigger: always_on
---

ExpenseLab es una aplicación de control financiero personal pensada como un producto offline-first, donde el usuario puede registrar y analizar sus finanzas sin depender de conexión a internet. La aplicación principal se desarrolla en Flutter, con soporte para mobile y desktop, y puede conectarse opcionalmente a un backend en ASP.NET Core Web API cuya responsabilidad principal es la sincronización, el respaldo de datos y el uso en múltiples dispositivos. En esta etapa, el foco del proyecto está en el modelo de dominio y en la consistencia de los datos, no en la interfaz visual.

El objetivo de ExpenseLab no es únicamente registrar gastos e ingresos básicos, sino ofrecer una base sólida para modelar situaciones financieras reales. El sistema debe permitir manejar múltiples cuentas, categorías y monedas, así como transacciones más complejas que las típicas entradas simples. La aplicación está pensada como un “laboratorio financiero personal”, donde la flexibilidad y la correcta representación de la realidad financiera son prioritarias frente a la simplicidad extrema.

Un concepto central del dominio es el manejo de transacciones con doble naturaleza. Una transacción puede afectar simultáneamente más de una cuenta y tener dos impactos distintos, como en una transferencia entre cuentas, una compra con tarjeta de crédito o el pago de una deuda. Esto implica que el modelo no debe asumir que toda transacción es simplemente un ingreso o un gasto aislado, sino que debe permitir representar movimientos compuestos de forma consistente y auditable.

ExpenseLab también debe soportar múltiples monedas desde el diseño del dominio. Cada cuenta tiene una moneda base y las transacciones pueden involucrar conversiones, registrando tanto el monto original como la tasa de cambio utilizada. El sistema no debe recalcular valores históricos con tasas actuales, ya que la precisión histórica es un requisito clave para reportes y análisis.

A nivel de arquitectura, la app en Flutter mantiene un almacenamiento local como fuente de verdad, pudiendo apoyarse opcionalmente en event sourcing local para tener historial completo de cambios y facilitar sincronización. Cuando exista backend, la sincronización debe ser incremental, tolerante a conflictos y pensada para escenarios offline prolongados. La IA que trabaje en este proyecto debe priorizar modelos claros, reglas explícitas de dominio, código mantenible y decisiones justificadas, evitando atajos que limiten la evolución futura del producto.
