# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create name: 'Comedy'
Category.create name: 'Animation'

videos = Video.create([
                        {
                          title: 'Monk',
                          description: 'Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the title character, Adrian Monk.',
                          small_cover_url: '/tmp/monk.jpg',
                          large_cover_url: '/tmp/monk_large.jpg',
                          category_id: 1
                        },
                        {
                          title: 'Futurama',
                          description: 'Futurama is an American animated science fiction comedy series created by Matt Groening for the Fox Broadcasting Company. The series follows the adventures of a late-20th-century New York City pizza delivery boy, Philip J. Fry, who, after being unwittingly cryogenically frozen for one thousand years, finds employment at Planet Express, an interplanetary delivery company in the retro-futuristic 31st century.',
                          small_cover_url: '/tmp/futurama.jpg',
                          large_cover_url: 'http://via.placeholder.com/665x375/E61E7F/FFFFFF',
                          category_id: 2
                        },
                        {
                         title: 'Family Guy',
                         description: 'Family Guy is an American animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company. The series centers on the Griffins, a family consisting of parents Peter and Lois; their children, Meg, Chris, and Stewie; and their anthropomorphic pet dog, Brian.',
                         small_cover_url: '/tmp/family_guy.jpg',
                         large_cover_url: 'http://via.placeholder.com/665x375/E61E7F/FFFFFF',
                         category_id: 1
                        }
                      ])


user1 = User.create email: 'foo@bar.com', password: '123456', full_name: 'Victor'
user2 = User.create email: 'qux@baz.com', password: '123456', full_name: 'Paolo'

VideoReview.create user: user1, video: Video.first, rating: 3, review: 'The best series'
VideoReview.create user: user2, video: Video.first, rating: 4, review: 'Really the best series'
