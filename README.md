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

<a name="practica"></a>
## Práctica: Dragon Ball App

![Demo app gif](images/demoApp.gif)

<a name="descripcion"></a>
### Descripción

Como práctica final al módulo de *iOS avanzado* del *Bootcamp* en Desarrollo de Apps Móviles, se nos ha propuesto el desarrollo de una **aplicación iOS siguiendo la arquitectura MVVM que consuma la *API Rest Dragon Ball* de *KeepCoding*.** Teniendo en cuenta los siguientes requisitos:

* **Obligatiorios**:
	* Listar los superhéroes.
	* Mostrar un mapa con los superhéroes.
	* Poder consultar los detalles de un héroe en particular desde la lista de superhéroes.
	* En la pantalla principal (lista de héroes) deberá existir un botón para hacer *log out*.

* **Opcionales**:
	* Poder consultar los detalles de un héroe en particular desde el mapa.
	* Añadir un buscador en la pantalla dónde se muestra la lista de superhéroes. Con este buscador, el usuario podrá buscar héroes. Una vez aparezcan los resultados, el usuario podrá consultar sus detalles.
	* Añadir un botón que permita limpiar la información almacenada en el dispositivo.

En mi caso, he querido poner en práctica todos los conocimientos que he ido adquiriendo y realizar una aplicación lo más completa posible en relación al tiempo que he podido dedicar; **atendiendo al diseño, la lógica y la ordenación y limpieza del código**.

<a name="arquitectura"></a>
### Arquitectura

Según [uncle Bob's Clean Architecture pattern](https://blog.cleancoder.com/uncle-bob/2011/11/22/Clean-Architecture.html), se puede dividir el código en 3 capas:

* *Presentation*: todo el código que depende del *framework*. *Views, ViewModels, Vierwcontrollers*, etc.
* *Data*: todo el código que interactúa con los repositorios (como llamadas a la red, llamadas a la base de datos, valores predeterminados de usuario, etc.).
* *Domain*: todos los modelos.

Siguiendo las indicaciones de Robert Cecil Martin, experto ingeniero de *software*, en el artículo que referencio; y guiado por MVVM, he construido mi código.

<a name="diseno"></a>
### Diseño

Para la parte más visual, estética y artística de la aplicación, he partido como inspiración del [concepto creativo y prototipo](https://dribbble.com/shots/22234085-Dragon-Ball-Z-Character-Info) del usuario llamado [Satyajit Mane](https://dribbble.com/Satyajit_Mane) encontrado en la web [Dribbble](https://dribbble.com/shots/22234085-Dragon-Ball-Z-Character-Info), punto de partida que me ha ayudado para comenzar el proyecto y diseñar el resto de pantallas intentando seguir la misma línea creativa.

Por otro lado, para la pantalla de *Login* me he inspirado en el [prototipo](https://dribbble.com/shots/14187565-Login-Page) del usuario llamado [Shubham Rathod](https://dribbble.com/shubhamdesign1) de [Dribbble](https://dribbble.com/shots/22234085-Dragon-Ball-Z-Character-Info).

Algunas características a nivel diseño y código serían:

* Interfaz de usuario conformada 100% programáticamente.
* `UICollectionView` con un `Header` y con celdas animadas con sombra y gradiente que aceptan pulsación inmediata y pulsación prolongada para ofrecer al usuario diversas funciones.
* Celdas `UITableView` animadas con sombra y gradiente.
* `UItableView` para la pantalla de *Favoritos* en las que sus celdas poseen un botón oculto a la derecha para eliminar del `UITableView`.
* Animación con la librería *Lottie*.
* `UITextField` que al ser pulsados despliegan una sombra de forma animada en pos de mejorar la experiencia de usuario.

<a name="problemas"></a>
### Problemas, decisiones y resolución

<a name="problemas1"></a>
#### Añadir gradiente a vista específica dentro de una `UITableViewCell`

Tuve un momento bloqueante al no conseguir la adicción de un gradiente a la `cardView` de la celda personalizada del `UITableView`. Al inicio, obtuve el gradiente como yo deseaba, incluyendo en la función `layoutSubviews` la configuración del gradiente; sin embargo, cada vez que realizaba *scroll* o pulsaba sobre la celda, el gradiente volvía a inicializarse y se iban acumulando constantemente gradientes.

Esto se debía solucionar agregando la configuración al `init` de la celda para que sólo se inicialice el gradiente una sola vez. No obstante, esto no funcionaba ya que no se aplicaba el gradiente a la vista `cardView` porque su tamaño no estaba aún establecido en ese punto del código.

De esta forma, realizando un proceso de *debug*, pude percatarme de la evolución que tenía el tamaño de la `cardView` a lo largo de la manipulación de la aplicación en el simulador y vi que parecía evidente que la solución pasaba por esperar que el tamaño de la `cardView` no fuera 0 y, además, debíamos asegurarnos que la gradiente solo se inicializara una sola vez para evitar acumulaciones y superposiciones.

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

Situación bloqueante a la que no encontré solución rápida, ya que creía haber implementado todo correctamente y, además, buscando información no encontraba la manera de resolverlo.

Aunque a ciencia cierta no sé con seguridad qué ocurría, he sacado algunas conclusiones de lo que podía suceder:

- Uso de varias capas y `UIView` que podían provocar superposición en algún momento del ciclo de vida de la vista.
- Empleo de `layoutSubviews()`, el cual se ejecuta cada vez que se carga o reusa una celda. Este método puede dar problemas cuando se usan varias capas, como me ocurrió en el problema anterior con el gradiente, el cual se superponía y acumulaba cada vez que interactuaba o reusaba una celda, provocando un efecto y comportamiento incorrectos.
- Que se cargara la imagen antes que alguna `UIView`, lo cual provocaba que no se viera.

Sin embargo, el análisis de estos casos y su respectivo cambio en el código, no me producía ningún avance, seguía obteniendo el mismo resultado.

Hasta que decidí probar a, en vez de posicionar la imagen en el `layoutSubviews()` con los `bounds` de la `UIView`, situar la imagen a través de *constraints*, consiguiendo el resultado que yo deseaba y evitando el mal comportamiento del `UICollectionView` con respecto a la aparición de la imagen.

<a name="problemas3"></a>
#### `UILabel` sobre gradiente

Al posicionar mi `UILabel` correctamente dentro de una `UIView` con una gradiente, tenía el problema de que la `UILabel` se colocaba dentrás de la gradiente.

La solución es simple: agregar la `UILabel` después de añadir la gradiente al `UIView`.

```swift
override func layoutSubviews() {
    super.layoutSubviews()
    
    // ...
    
	addGradient()
	cardView.addSubview(heroNameLabel)
}
```

Además, no debemos olvidar volver a agregar el `UILabel` también cuando inicializamos todas las vistas en general.

```swift
private func addViews() {
    // ...
    cardView.addSubview(heroNameLabel)
}
```

<a name="problemas4"></a>
#### Mala adjudicación del tag del `UIButton` cada vez que se creaba una `annotation` en la función `mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?` del `MKMapViewDelegate` 

A pesar de poder navegar al detalle del personaje empleando el método `didSelect` del `MKMapViewDelegate`, no me gustaba el efecto que realizaba ya que navegaba directamente sin que el usuario pudiera saber a qué pertenece ese *pin* en el mapa y pudiera decidir si quiere ampliar información.

Por tanto, decidí crear un botón personalizado a la derecha del nombre del personaje para que, así, el usuario tuviera la capacidad de elegir si quiere o no saber más. Sin embargo, tuve problemas con la adjudicación del modelo del héroe a cada botón una vez que se instanciaba.

Cuando lo desarrollé por primera vez, el comportamiento era correcto con los *pins* que se inicializaban por primera vez en el mapa; pero, a la hora de inicializar aquellos que se reusaban, no estaba aportándole al botón un *tag* al botón `rightButton` cuando `annotationView` era `nil`. Esto sucedía en el bloque `if` del código. Así que cuando navegaba por el mapa y encontraba *pins* que no se habían inicializado al aparecer la vista completa, navegaba al detalle de un héroe que no era el correcto.

Se quería asignar un *tag* al botón incluso cuando el código entrara en la parte del `else`, es decir, cuando `annotationView` no era `nil`, por lo que se movió la lógica de asignación del *tag* y la adición de la anotación fuera de las condiciones `if` y `else`. De esta manera, independientemente de si `annotationView` es `nil` o no, se asignará el *tag* al botón `rightButton`.

Esto significa que ahora se está asignando un *tag* a `rightButton` tanto en el caso de que `annotationView` sea `nil` (cuando se crea una nueva vista de anotación) como en el caso de que no lo sea (cuando se reutiliza una vista de anotación existente).

<a name="problemas5"></a>
#### *Testing* sobre la capa de modelo

La API Rest empleada aquí ya la usé en otro [proyecto](https://github.com/salvaMsanchez/fundamentos-ios-bootcamp), en el que realizaba las llamadas con `dataTask` y sobre las que ya realicé *tests* unitarios. Fue así que decidí cambiar en este proyecto y hacer las llamadas con `async/await`. Sin embargo, no fui capaz de pasarle los *tests* unitarios ya que no conseguí realizar un `MockProtocol` que respondiera correctamente. Se trata de uno de los puntos en los que debo seguir investigando. 

Es por todo esto que, al final, no añadí *tests* unitarios a la capa de modelo. No obstante, realicé *Unit Testing* para `SecureDataProvider` (*Keychain*), para `UserDefaultsManager`, para `DataPersistanceManager` (*CoreData*) y para algunos métodos aislados.

<a name="mejoras"></a>
# Algunos aspectos en los que seguir mejorando la aplicación

* Tamaños y estilo adecuados respecto a la tipografía empleada.
* Limpieza de los números colocados "a fuego" en el código y no agrupados en constantes o *enums*.
* Agrupar los texto que no son dinámicos en el ciclo de vida de la aplicación en archivos localizables y que puedan ser traducidos a otros idiomas.
* Falta realizar tareas de refactorización y ver qué se podría reutilizar a través del uso de genéricos como se podría hacer en la clase que emplea *Keychain* o en el uso de un solo `DetailView` en vez de haber ocnstruido dos casi idénticos.
* Se podría analizar y estudiar la separación de los elementos de la UI que ahora solo están incluidos en el `ExploreViewController` por facilidad de desarrollo. Sin embargo, sería adecuado desacoplar para tener un código más escalable y reutilizable en un futuro.
* Eliminar mensajes de error cuando ya no son necesarios como, por ejmplo, cuando se pulsa en una celda de nuevo tras errar. Esto lo podríamos hacer en el delegado correspondiente a los `UITextField`.

---

[Subir ⬆️](#top)

---
