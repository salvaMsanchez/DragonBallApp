<a name="top"></a>

<h1 align="center">
  <strong><span>Bootcamp Desarrollo de Apps Móviles</span></strong>
</h1>

---

<p align="center">
  <strong><span style="font-size:20px;">Módulo: iOS avanzado 🍏</span></strong>
</p>

---

<p align="center">
  <strong>Autor:</strong> Salva Moreno Sánchez
</p>

<p align="center">
  <a href="https://www.linkedin.com/in/salvador-moreno-sanchez/">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
  </a>
</p>

## Índice
 
* [Herramientas](#herramientas)
* [Práctica: Dragon Ball Heroes App](#practica)
	* [Descripción](#descripcion)
	* [Arquitectura](#arquitectura)
	* [Diseño](#diseno) 
	* [Problemas, decisiones y resolución](#problemas)
		* [Añadir gradiente a vista específica dentro de una `UITableViewCell`](#problemas1)
		* [Comportamiento inesperado `UICollectionViewCell`: la imagen y el gradiente aparecen en celdas que no se ven en pantalla y cuando pulsas en ellas, aparecen](#problemas2)
		* [`UILabel` sobre gradiente](#problemas3)
		* [Mala adjudicación del tag del `UIButton` cada vez que se creaba una `annotation` en la función `mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?` del `MKMapViewDelegate`](#problemas4)
		* [*Testing* sobre la capa de modelo](#problemas5)
	* [Algunos aspectos en los que seguir mejorando la aplicación](#mejoras)

<a name="herramientas"></a>
## Herramientas

<p align="center">

<a href="https://www.apple.com/es/ios/ios-17/">
   <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white" alt="iOS">
 </a>
  
 <a href="https://www.swift.org/documentation/">
   <img src="https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white" alt="Swift">
 </a>
  
 <a href="https://developer.apple.com/xcode/">
   <img src="https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white" alt="XCode">
 </a>
  
</p>

* **iOS:** 16
* **Swift:** 5.9
* **Xcode:** 14.3.1

<a name="practica"></a>
## Práctica: Dragon Ball App

![Demo app gif](images/demoApp.gif)

<a name="descripcion"></a>
### Descripción

Como práctica final al módulo de *iOS avanzado* del *Bootcamp* en Desarrollo de Apps Móviles, se nos ha propuesto el desarrollo de una **aplicación iOS siguiendo la arquitectura MVVM que consuma la *API Rest Dragon Ball* de *KeepCoding*.** Teniendo en cuenta los siguientes requisitos:

* **Obligatorios**:
	* Listar los superhéroes.
	* Mostrar un mapa con los superhéroes.
	* Poder consultar los detalles de un héroe en particular desde la lista de superhéroes.
	* En la pantalla principal (lista de héroes) deberá existir un botón para hacer *log out*.

* **Opcionales**:
	* Poder consultar los detalles de un héroe en particular desde el mapa.
	* Añadir un buscador en la pantalla dónde se muestra la lista de superhéroes. Con este buscador, el usuario podrá buscar héroes. Una vez aparezcan los resultados, el usuario podrá consultar sus detalles.
	* Añadir un botón que permita limpiar la información almacenada en el dispositivo.

En mi caso, he querido poner en práctica todos los conocimientos que he ido adquiriendo y realizar una aplicación lo más completa posible en relación al tiempo que he podido dedicar, incluso ampliando los conocimientos con investigaciones propias; **atendiendo al diseño, la lógica, y la ordenación y limpieza del código**.

<a name="arquitectura"></a>
### Arquitectura

Según [uncle Bob's Clean Architecture pattern](https://blog.cleancoder.com/uncle-bob/2011/11/22/Clean-Architecture.html), se puede dividir el código en 3 capas:

* *Presentation*: todo el código que depende del *framework*. *Views, ViewModels, ViewControllers*, etc.
* *Data*: todo el código que interactúa con los repositorios (como llamadas a red, llamadas a la base de datos, valores predeterminados de usuario, etc.).
* *Domain*: todos los modelos de datos.

Siguiendo las indicaciones del citado Robert Cecil Martin, experto ingeniero de *software*, y guiado por MVVM, he construido mi código.

<a name="diseno"></a>
### Diseño

Para la parte más visual, estética y artística de la aplicación, he partido como **inspiración del [concepto creativo y prototipo](https://dribbble.com/shots/22234085-Dragon-Ball-Z-Character-Info)** del usuario llamado [Satyajit Mane](https://dribbble.com/Satyajit_Mane) encontrado en la web [Dribbble](https://dribbble.com), punto de partida que me ha ayudado para comenzar el proyecto y diseñar el resto de pantallas intentando seguir la misma línea creativa.

Por otro lado, para la pantalla de *Login* me he **inspirado en el [prototipo](https://dribbble.com/shots/14187565-Login-Page)** del usuario llamado [Shubham Rathod](https://dribbble.com/shubhamdesign1) de [Dribbble](https://dribbble.com).

Algunas características a destacar a nivel diseño y código serían:

* Interfaz de usuario conformada **100% programáticamente**.
* **`UICollectionView` con un `Header` y con celdas animadas con sombra y gradiente** que aceptan **pulsación inmediata** (navegación al detalle del personaje) y **pulsación prolongada** (aparición de menú contextual en que puedes agregar y eliminar personaje de la sección de favoritos) para ofrecer al usuario diversas funcionalidades.
* **Celdas `UITableView` animadas con sombra y gradiente**.
* **`UISearchController` que emplea el algoritmo de la similitud de Jaccard**, como ya empleé y expuse en otro [proyecto](https://github.com/salvaMsanchez/pokedex-app-mvvm#problemas2), para realizar búsquedas de personajes.
* **`UItableView` para la pantalla de *Favoritos* en las que sus celdas poseen un botón oculto de tipo `.destructive` a la derecha para que puedan ser eliminadas** del `UITableView`.
* **Animación con la librería *Lottie*.**
* **Empleo de `MapKit`** para reflejar un mapa que incluya todas las **localizaciones de los personajes con *annotations* personalizadas y botón de información incluido en el *title* para poder navegar al detalle del personaje**, el cual aparece de forma *modal* personalizada.
* **`UITextField` que al ser pulsados despliegan una sombra de forma animada** en pos de mejorar la experiencia de usuario.

<a name="problemas"></a>
### Problemas, decisiones y resolución

<a name="problemas1"></a>
#### Añadir gradiente a vista específica dentro de una `UITableViewCell`

Experimenté un desafío cuando intentaba aplicar un gradiente a la `cardView` de la celda personalizada en mi `UITableView`. Inicialmente, logré configurar el gradiente según mis preferencias al incluir la configuración en la función `layoutSubviews`. No obstante, enfrenté un problema: cada vez que hacía *scroll* o tocaba la celda, el gradiente se reiniciaba, lo que resultaba en una acumulación constante de gradientes no deseados.

La solución a este problema parecía estar en incorporar la configuración en el método `init` de la celda, con la intención de que el gradiente se inicializara solo una vez. Sin embargo, esta estrategia no funcionaba debido a que en ese punto del código, el tamaño de la vista `cardView` aún no estaba establecido, lo que impedía la aplicación efectiva del gradiente.

Siguiendo un proceso de depuración (*debugging*), observé cómo evolucionaba el tamaño de la `cardView` durante la interacción con la aplicación en el simulador. Fue evidente que la solución requería esperar a que el tamaño de la `cardView` no fuera igual a cero y, al mismo tiempo, garantizar que el gradiente se inicializara una sola vez para evitar acumulaciones y superposiciones no deseadas.

Así quedaría la `UITableViewCell` para conseguir la solución:

```swift
final class SearchTableViewCell: UITableViewCell {
    // ...
    
    private var gradientAdded = false
    
    // ...
    
    public func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.systemOrange.cgColor
        ]
        gradientLayer.locations = [0.01, 0.1, 0.7, 1.0]
        gradientLayer.frame = cardView.bounds
        gradientLayer.cornerRadius = 20
        cardView.layer.addSublayer(gradientLayer)
    }
   
   	// ...
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = cardView.bounds
        
        if !gradientAdded && cardView.bounds != .zero {
            addGradient()
            gradientAdded = true
        }
    }
    
    // ...
    
}
```

<a name="problemas2"></a>
#### Comportamiento inesperado `UICollectionViewCell`: la imagen y el gradiente aparecen en celdas que no se ven en pantalla y cuando pulsas en ellas, aparecen

La situación se convirtió en un obstáculo que no pude resolver de manera inmediata, ya que tenía la impresión de haber implementado todo de forma adecuada, y además, no encontraba información útil que me ayudara a encontrar una solución.

Aunque no puedo afirmar con total certeza lo que estaba sucediendo, he llegado a algunas conclusiones sobre posibles causas:

- El uso de múltiples capas y vistas (`UIView`) que podrían generar superposiciones en algún punto del ciclo de vida de la vista.
- La utilización de `layoutSubviews()`, el cual se activa cada vez que se carga o reutiliza una celda. Este método puede causar problemas al emplear múltiples capas, como ocurrió en el problema anterior con el gradiente, que se superponía y acumulaba con cada interacción o reutilización de la celda, lo que generaba un comportamiento incorrecto.
- La carga de la imagen antes que alguna `UIView`, lo que provocaba que esta última no fuera visible.

No obstante, a pesar de analizar estas situaciones y realizar modificaciones en el código correspondiente, no lograba avanzar, y el resultado seguía siendo el mismo.

Fue entonces cuando decidí probar una solución diferente. En lugar de posicionar la imagen dentro de `layoutSubviews()` utilizando los límites (`bounds`) de la `UIView`, opté por colocar la imagen mediante restricciones (*constraints*). Este enfoque me permitió lograr el resultado deseado y evitó el comportamiento no deseado en el `UICollectionView` con respecto a la visualización de la imagen.

<a name="problemas3"></a>
#### `UILabel` sobre gradiente

Al posicionar mi `UILabel` correctamente dentro de una `UIView` que tenía un gradiente, surgió un nuevo problema: la `UILabel` quedaba detrás del gradiente.

La solución es sencilla: agregar la `UILabel` después de haber configurado el gradiente en la `UIView`.

```swift
override func layoutSubviews() {
    super.layoutSubviews()
    
    // ...
    
	addGradient()
	cardView.addSubview(heroNameLabel)
}
```


Además, es importante recordar que debemos volver a agregar la `UILabel` al inicializar todas las vistas en general.

```swift
private func addViews() {
    // ...
    cardView.addSubview(heroNameLabel)
}
```

<a name="problemas4"></a>
#### Mala adjudicación del tag del `UIButton` cada vez que se creaba una `annotation` en la función `mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?` del `MKMapViewDelegate` 


A pesar de poder acceder al detalle del personaje mediante el método `didSelect` del `MKMapViewDelegate`, no me satisfacía el efecto que se producía, ya que la navegación se realizaba de manera directa, sin dar al usuario la oportunidad de identificar a qué corresponde ese marcador en el mapa y decidir si desea obtener más información.

Por lo tanto, opté por diseñar un botón personalizado ubicado a la derecha del *title* de la *annotation*, para dar al usuario la capacidad de decidir si desea obtener información adicional o no. No obstante, experimenté dificultades al asignar el modelo del héroe a cada botón una vez que este se instanciaba.

Cuando desarrollé esta funcionalidad por primera vez, el comportamiento era correcto con los marcadores que se inicializaban en el mapa por primera vez. Sin embargo, al tratar de reutilizar los marcadores, cometí un error al no asignar una etiqueta (`tag`) al botón `rightButton` cuando `annotationView` era nulo, dentro del bloque `if` del código. Esto resultó en un problema cuando exploraba el mapa y encontraba marcadores que no se habían inicializado al aparecer la vista completa, lo que llevaba a la navegación al detalle de un héroe incorrecto.

La solución consistió en asignar un `tag` al botón incluso cuando el código entrara en la parte del else, es decir, cuando `annotationView` no era nulo. Para lograr esto, reorganicé la lógica de asignación del `tag` y la adición de la anotación fuera de las condiciones `if` y `else`. De esta forma, independientemente de si `annotationView` es nulo o no, el `tag` se asignará al botón `rightButton`.

Esto implica que actualmente se asigna un `tag` a `rightButton` tanto cuando `annotationView` es nulo (cuando se crea una nueva vista de anotación) como cuando no lo es (cuando se reutiliza una vista de anotación existente).

<a name="problemas5"></a>
#### *Testing* sobre la capa de modelo


La *API Rest* que se utiliza aquí ya la había empleado en otro [proyecto](https://github.com/salvaMsanchez/fundamentos-ios-bootcamp), en el cual realizaba las llamadas utilizando `dataTask` y había implementado pruebas unitarias con éxito. Por eso, en este proyecto, decidí cambiar y utilizar `async/await` para las llamadas. No obstante, no logré pasar las pruebas unitarias, ya que no fui capaz de crear un `MockProtocol` que respondiera correctamente. Este es uno de los aspectos en los que necesito continuar investigando.

Es por todo esto que, al final, no añadí pruebas unitarias sobre la capa de modelo. Sin embargo, llevé a cabo *unit testing* para `SecureDataProvider` (*Keychain*), para `UserDefaultsManager`, para `DataPersistanceManager` (*CoreData*) y para algunos métodos aislados.

<a name="mejoras"></a>
# Algunos aspectos en los que seguir mejorando la aplicación

* Tamaños y estilo adecuados respecto a la tipografía empleada.
* Limpieza de los números colocados "a fuego" en el código y no agrupados en constantes o *enums*.
* Agrupar los textos que no son dinámicos en el ciclo de vida de la aplicación en archivos localizables y que puedan ser traducidos a otros idiomas.
* Falta realizar tareas de refactorización y analizar qué se podría reutilizar a través de, por ejemplo, el uso de genéricos, como se podría hacer en la clase que emplea *Keychain* o en el uso de un solo `DetailView` en vez de haber construido dos casi idénticos.
* Se podría analizar y estudiar la separación de los elementos de la UI que ahora solo están incluidos en el `ExploreViewController` por facilidad de desarrollo. Sin embargo, sería adecuado desacoplar para tener un código más escalable y reutilizable en un futuro.
* Eliminar mensajes de error en la vista de `Login` cuando ya no son necesarios como, por ejemplo, cuando se pulsa en una celda de nuevo tras haber ya errado en la autenticación. Esto lo podríamos hacer en el delegado correspondiente a los `UITextField`.

---

[Subir ⬆️](#top)

---
