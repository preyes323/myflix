# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


videos = Video.create([
                        {
                          title: 'Monk',
                          description: 'Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the title character, Adrian Monk.',
                          small_cover_url: '/tmp/monk.jpg',
                          large_cover_url: '/tmp/monk_large.jpg'
                        },
                        {
                          title: 'Futurama',
                          description: 'Futurama is an American animated science fiction comedy series created by Matt Groening for the Fox Broadcasting Company. The series follows the adventures of a late-20th-century New York City pizza delivery boy, Philip J. Fry, who, after being unwittingly cryogenically frozen for one thousand years, finds employment at Planet Express, an interplanetary delivery company in the retro-futuristic 31st century.',
                          small_cover_url: '/tmp/futurama.jpg',
                          large_cover_url: 'http://via.placeholder.com/665x375/E61E7F/FFFFFF'
                        }
                      ])
