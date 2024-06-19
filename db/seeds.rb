require 'faker'

INITIAL_GENRES = ['Fantasy', 'Science-fiction', 'Romance', 'Histoire', 'Shonen', 'Seinen', 'Shoujo', 'Jeunesse', 'Fantastique', 'Biographie', 'Action', 'Horreur', 'Thriller', 'Policier', 'Mélo', 'Conte']

puts 'Destroying all instances...'

User.destroy_all
Book.destroy_all
Serie.destroy_all
Genre.destroy_all
BookGenre.destroy_all
Collection.destroy_all
FavoriteSerie.destroy_all

puts 'Done'

# images = ['cityoforange.jpeg', 'dune.jpeg', 'greatgatsby.jpeg', 'lotr.jpeg']

puts 'Creating users and series...'

pierre = User.create(nickname: "Pierre", email: "pierre@gmail.com", password: 123456, public: true)
john = User.create(nickname: "John", email: "john@gmail.com", password: 123456)
maria = User.create(nickname: "Maria", email: "maria@gmail.com", password: 123456)
# Serie.create(name: "Super série", books_total: 7, status: "Terminée")
# Serie.create(name: "Mauvaise série", books_total: 5, status: 'En cours')

puts 'Done'

puts 'Creating books...'

# 10.times{
#   b = Book.new(
#       title: Faker::Book.unique.title,
#       serie_number: rand(10),
#       book_type: Book::TYPES.sample,
#       serie: Serie.all.sample,
#       description: Faker::Lorem.sentence(word_count: 15),
#       isbn: "978 - 2 - 7177 - 2113 - 4",
#       release: Date.today-rand(10000),
#       author: Faker::Book.author,
#       illustrator: Faker::Book.author,
#       edition: Faker::Book.publisher,
#       illustrations: ["dz2btx3jhn9pqpvpnolp", "dz2btx3jhn9pqpvpnolp", "dz2btx3jhn9pqpvpnolp"]
#     )
#   filename = images.sample
#   b.cover_img.attach(io: File.open("app/assets/images/#{filename}"), filename: filename, content_type: "image/jpg")
#   b.save!
# }



INITIAL_GENRES.each { |name|
  Genre.create(name: name)
}

puts 'Done'

puts 'Creating collections...'

# Book.all.each do |book|
#   (1 + rand(2)).times do
#     BookGenre.create(
#       book: book,
#       genre: Genre.all.sample
#     )
#   end

#   Collection.create(
#     comment: Faker::Lorem.sentence(word_count: 15),
#     is_read: [false, true].sample,
#     is_favorited: [false, true].sample,
#     book: book,
#     user: User.all.sample
#   )
# end

User.all.each do |user|
  FavoriteSerie.create(
    user: user,
    serie: Serie.all.sample
  )
end

puts 'Done'

puts 'other seeds'

croisee_serie = Serie.create(name: "À la croisée des mondes", books_total: 3, status: "Terminée")
oneira_serie = Serie.create(name: "Oneira", books_total: 4, status: "En cour")

# creer les livre de la croisee des mondes

puts "crees croise des mondes"
cr = Book.new({
  title: 'Les Royaumes du Nord',
  serie_number: 1,
  book_type: 'Roman',
  serie: croisee_serie,
  description: "Élevée dans le très austère Jordan College à Oxford, Lyra Belacqua accompagnée de son dæmon Pantalaimon, apprend accidentellement l'existence de la Poussière, une étrange particule élémentaire que le Magisterium (l'organe exécutif de l'Église) pense être la conséquence du Péché originel.",
  author: 'Philip Pullman',
  release: Date.new(1998),
  edition: 'Gallimard'
})
cr.cover_img.attach(io: File.open("app/assets/images/croisee1.jpg"), filename: 'croisee1', content_type: "image/jpg")
cr.save!
Collection.create(
    comment: Faker::Lorem.sentence(word_count: 15),
    is_read: [false, true].sample,
    is_favorited: [false, true].sample,
    book: cr,
    user: pierre
  )

cr = Book.create({
  title: 'La Tour des anges',
  serie_number: 2,
  book_type: 'Roman',
  serie: croisee_serie,
  description: "Lyra entre dans un autre monde, celui de Cittàgazze, dont les adultes sont absents à cause de créatures mangeuses d'âmes appelées Spectres qui ont pour cibles tous les humains ayant passé la puberté. Ici, Lyra rencontre Will Parry, un garçon de douze ans qui vient de notre monde et qui est arrivé dans celui-ci après avoir tué accidentellement un homme pour protéger sa mère malade.",
  author: 'Philip Pullman',
  release: Date.new(2000),
  edition: 'Gallimard'
})
cr.cover_img.attach(io: File.open("app/assets/images/croisee2.jpg"), filename: 'croisee2', content_type: "image/jpg")
cr.save!

Collection.create(
    comment: Faker::Lorem.sentence(word_count: 15),
    is_read: [false, true].sample,
    is_favorited: [false, true].sample,
    book: cr,
    user: pierre
  )

cr = Book.create({
  title: "Le Miroir d'ambre",
  serie_number: 3,
  book_type: 'Roman',
  serie: croisee_serie,
  description: "Will décide de partir à la recherche de Lyra, qui est retenue prisonnière par sa mère Mme Coulter en Himalaya. Il rencontre au cours de son périple Iorek Byrnison avec qui il va chercher Lyra. Avec l'aide d'une fille de la région, Ama, ils arrachent Lyra des griffes de Mme Coulter, pour ensuite entamer un voyage au royaume des morts. Ils découpent une fenêtre dans ce monde, pour laisser les fantômes des morts s'échapper et faire de nouveau corps avec la nature. ",
  author: 'Philip Pullman',
  release: Date.new(2001),
  edition: 'Gallimard'
})
cr.cover_img.attach(io: File.open("app/assets/images/croisee3.jpg"), filename: 'croisee3', content_type: "image/jpg")
cr.save!

Collection.create(
    comment: Faker::Lorem.sentence(word_count: 15),
    is_read: [false, true].sample,
    is_favorited: [false, true].sample,
    book: cr,
    user: pierre
  )

puts "Cree oneira"

horreur = Genre.find_by(name: 'Horreur')
fantasy = Genre.find_by(name: 'Fantasy')
action = Genre.find_by(name: 'Action')

on = Book.create({
  title: "Oneira t. 1",
  serie_number: 1,
  book_type: "Manga",
  serie: oneira_serie,
  description: "Sortis des tréfonds de nos esprits, les cauchemars ont pris vie. Animés par leur seul désir d'éliminer leurs hôtes, ces monstres, aux multiples formes, sont devenus un fléau à éradiquer. Devant cette menace grandissante, la caste des Épeires s'est vu ériger en bras armé de l'Église afin de se dresser contre les créatures des songes. Arane Heos, la tristement célèbre « Croque-mitaine », est l'une de ces Épeires. Tout en affrontant les cauchemars, elle devra faire face au tumulte grandissant au sein de l'Église et de sa caste, lequel menace désormais le secret qui entoure son enfant.",
  author: "Federica Di Meo",
  release: Date.new(2022, 06, 17),
  edition: "Kana"
})

BookGenre.create!(book: on, genre: horreur)
BookGenre.create!(book: on, genre: fantasy)
BookGenre.create!(book: on, genre: action)
on.cover_img.attach(io: File.open("app/assets/images/seeds/oneira-t1.png"), filename: "oneira-t1", content_type: "image/png")
on.save!

Collection.create({
  comment: "",
  is_read: true,
  is_favorited: true,
  book: on,
  user: pierre
})

on = Book.create({
  title: "Oneira t. 2",
  serie_number: 2,
  book_type: "Manga",
  isbn: '9782505086314',
  serie: oneira_serie,
  description: "Venus pousse Arane Heos à lui révéler sa véritable nature. Avec l'aide de Bastione, la Croque-mitaine lui raconte les circonstances particulières de sa naissance. Les paladins aux ordres du cardinal Lemegeton se rapprochent d'Heosias, menaçant de s'en prendre à Venus.",
  author: "Federica Di Meo",
  # genre:  Action - Fantasy - Horreur - Thriller
  release: Date.new(2022, 9, 2),
  edition: "Kana"
})

BookGenre.create!(book: on, genre: horreur)
BookGenre.create!(book: on, genre: fantasy)
BookGenre.create!(book: on, genre: action)
on.cover_img.attach(io: File.open("app/assets/images/seeds/oneira-t2.png"), filename: "oneira-t1", content_type: "image/png")
on.save!

Collection.create({
  comment: "",
  is_read: true,
  is_favorited: true,
  book: on,
  user: pierre
})

on = Book.create({
  title: "Oneira t. 3",
  serie_number: 3,
  book_type: "Manga",
  serie: oneira_serie,
  description: "Maintenant que le cardinal Lemegeton a révélé son vrai visage, l'affrontement semble inévitable. Venus et Bastione, pris au piège, n'ont d'autre choix que de se lancer dans une sanglante bataille. De son côté, Arane, en proie au chagrin, se laisse emporter par la rage du combat, mais cet exutoire sera-t-il suffisant pour apaiser son cœur ?",
  author: "Federica Di Meo",
  # genre:  Action - Fantasy - Horreur - Thriller
  release: Date.new(2023, 02, 17),
  edition: "Kana"
})

BookGenre.create!(book: on, genre: horreur)
BookGenre.create!(book: on, genre: fantasy)
BookGenre.create!(book: on, genre: action)
on.cover_img.attach(io: File.open("app/assets/images/seeds/oneira-t3.png"), filename: "oneira-t1", content_type: "image/png")
on.save!

Collection.create({
  comment: "",
  is_read: true,
  is_favorited: true,
  book: on,
  user: pierre
})

on = Book.create({
  title: "Oneira t. 4",
  serie_number: 4,
  book_type: "Manga",
  isbn: '9782505087687',
  serie: oneira_serie,
  description: "Maintenant réunis dans la bataille, Salomon et Chevreul constituent une terrible menace et se rapprochent de leur ultime dessein : absorber l'essence de Venus.Et, si de son côté Arane peut compter sur l'aide de Bastione et de sa fille, l'impitoyable cardinal saura exploiter les failles du Croque-mitaine afin de semer la discorde tant dans l'esprit d'Arane que dans les rangs de nos protagonistes.",
  author: "Federica Di Meo",
  # genre:  Action - Fantasy - Horreur - Thriller
  release: Date.new(2023, 11, 24),
  edition: "Kana"
})

BookGenre.create!(book: on, genre: horreur)
BookGenre.create!(book: on, genre: fantasy)
BookGenre.create!(book: on, genre: action)
on.cover_img.attach(io: File.open("app/assets/images/seeds/oneira-t4.png"), filename: "oneira-t1", content_type: "image/png")
on.save!

Collection.create({
  comment: "",
  is_read: true,
  is_favorited: true,
  book: on,
  user: maria
})



puts 'Done'


# John Books
cr = Book.create!({
  title: "Les fleurs du mal",
  book_type: "Poesie",
  cover_url: "https://covers.openlibrary.org/b/id/8236412-M.jpg",
  description:
   "Les Fleurs du mal est un recueil de poèmes de Charles Baudelaire, reprenant la quasi-totalité de sa production en vers de 1840 jusqu'à sa mort, survenue fin août 1867. ",
  isbn: "3847243500",
  release: Date.new(1855),
  author: "Charles Baudelaire",
  edition: "Mestas"
})
Collection.create(
  is_read: [true].sample,
  is_favorited: [true].sample,
  book: cr,
  user: maria
)

cr = Book.create!({title: "Le Roi sur le Seuil",
  book_type: "Roman",
  cover_url: "https://covers.openlibrary.org/b/id/3163776-M.jpg",
  description:
   "L'histoire se déroule environ un siècle après le siège de Dros Delnoch par les Nadirs d'Ulric. Descendant, pour des raisons d'alliances, à la fois d'Ulric et de Regnak qui furent deux adversaires acharnés lors du siège de Dros Delnoch, Tenaka Khan n'est à sa place nulle part.",
  isbn: "2914370075",
  release: Date.new(2001),
  author: "David A. Gemmell",
  edition: "Bragelonne"
})
Collection.create(
  is_read: [false].sample,
  is_favorited: [false].sample,
  book: cr,
  user: maria
)

cr = Book.create!({title: "Alcools",
  book_type: "Poesie",
  cover_url: "https://covers.openlibrary.org/b/id/10728112-M.jpg",
  description:
   "Alcools est un recueil pluriel, polyphonique, qui explore de nombreux aspects de la poésie, allant de l'élégie au vers libre, mélangeant le quotidien aux paysages rhénans dans une poésie qui se veut expérimentale, alliant un travail sur la forme et sur l'esthétique à un hermétisme et un art du choc.",
  isbn: "9782761613668",
  release: Date.new(1944),
  author: "Guillaume Apollinaire",
  edition: "Flammarion"
})

Collection.create(
  is_read: [true].sample,
  is_favorited: [false].sample,
  book: cr,
  user: maria
)

cr = Book.create!({
  title: "L’étranger",
  book_type: "Roman",
  cover_url: "https://covers.openlibrary.org/b/id/13151269-M.jpg",
  description:
   "L'Étranger est le premier roman publié d'Albert Camus, paru en 1942. Les premières esquisses datent de 1938, mais le roman ne prend vraiment forme que dans les premiers mois de 1940 et sera travaillé par Camus jusqu’en 1941.",
  isbn: "9789687349244",
  release: Date.new(1942),
  author: "Albert Camus",
  edition: "Folioplus Classiques"
})

Collection.create(
  is_read: [true].sample,
  is_favorited: [true].sample,
  book: cr,
  user: maria
)
