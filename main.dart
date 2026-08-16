8888
٣import 'package:flutter/material.dart';

void main() => runApp(const SuwedaApp());

class Product {
  final String name, price, category;
  const Product(this.name, this.price, this.category);
}

const products = [
  Product('هاتف ذكي 128GB', '2,350,000 ل.س', 'إلكترونيات'),
  Product('ساعة ذكية', '175,000 ل.س', 'إلكترونيات'),
  Product('حذاء رياضي رجالي', '150,000 ل.س', 'ملابس'),
  Product('قلاية هوائية', '320,000 ل.س', 'منزل ومطبخ'),
  Product('عطر رجالي فاخر', '210,000 ل.س', 'تجميل وعطور'),
  Product('دمبل رياضي 10 كغ', '180,000 ل.س', 'رياضة'),
];

class SuwedaApp extends StatelessWidget {
  const SuwedaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'سويدا',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF4D1A)),
      ),
      home: const Store(),
    );
  }
}

class Store extends StatefulWidget {
  const Store({super.key});
  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  int tab = 0;
  final cart = <Product>[];

  void add(Product p) {
    setState(() => cart.add(p));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تمت إضافة ${p.name} للسلة')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Home(onAdd: add),
      Categories(onAdd: add),
      Cart(cart: cart, onDelete: (p) => setState(() => cart.remove(p))),
      const Account(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: pages[tab],
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (i) => setState(() => tab = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.grid_view_outlined), label: 'الأقسام'),
            NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'السلة'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
          ],
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  final void Function(Product) onAdd;
  const Home({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('سويدا SUWEDA', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const Text('كل شي قريب منك'),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            hintText: 'ابحث عن منتج أو متجر...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 150,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(colors: [Color(0xFF170A24), Color(0xFF6B1765)]),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('عروض سويدا', style: TextStyle(color: Colors.white, fontSize: 18)),
              Text('خصومات تصل حتى 50%', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('منتجات مميزة', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .72,
          ),
          itemBuilder: (_, i) => Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => showProduct(context, products[i], onAdd),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.shopping_bag_outlined, size: 70, color: Colors.black38),
                    )),
                    const SizedBox(height: 8),
                    Text(products[i].name, maxLines: 2, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(products[i].price, style: const TextStyle(color: Color(0xFFE63D16), fontWeight: FontWeight.w800)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(onPressed: () => onAdd(products[i]), icon: const Icon(Icons.add_shopping_cart)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

void showProduct(BuildContext context, Product p, void Function(Product) onAdd) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            Container(
              height: 220, width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.black38),
            ),
            const SizedBox(height: 16),
            Text(p.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(p.category),
            const SizedBox(height: 8),
            Text(p.price, style: const TextStyle(fontSize: 24, color: Color(0xFFE63D16), fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: FilledButton.icon(
              onPressed: () { onAdd(p); Navigator.pop(context); },
              icon: const Icon(Icons.shopping_cart), label: const Text('أضف إلى السلة'),
            )),
          ],
        ),
      ),
    ),
  );
}

class Categories extends StatelessWidget {
  final void Function(Product) onAdd;
  const Categories({super.key, required this.onAdd});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('الأقسام', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        ...products.map((p) => Card(child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.category_outlined)),
          title: Text(p.category),
          subtitle: Text(p.name),
          trailing: IconButton(icon: const Icon(Icons.add_shopping_cart), onPressed: () => onAdd(p)),
        ))),
      ],
    ),
  );
}

class Cart extends StatelessWidget {
  final List<Product> cart;
  final void Function(Product) onDelete;
  const Cart({super.key, required this.cart, required this.onDelete});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: cart.isEmpty
      ? const Center(child: Text('السلة فارغة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)))
      : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('السلة', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          ...cart.map((p) => Card(child: ListTile(
            title: Text(p.name), subtitle: Text(p.price),
            trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => onDelete(p)),
          ))),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('إتمام الطلب'),
                content: const Text('سيتم تجهيز الطلب للدفع عند الاستلام.'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسنًا'))],
              ),
            ),
            child: const Text('متابعة الطلب'),
          ),
        ],
      ),
  );
}

class Account extends StatelessWidget {
  const Account({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('حسابي', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        SizedBox(height: 12),
        Card(child: ListTile(leading: Icon(Icons.person), title: Text('تسجيل الدخول'), subtitle: Text('ادخل إلى حسابك'))),
        Card(child: ListTile(leading: Icon(Icons.store_outlined), title: Text('حساب البائع'), subtitle: Text('إدارة متجرك ومنتجاتك'))),
        Card(child: ListTile(leading: Icon(Icons.receipt_long), title: Text('طلباتي'))),
        Card(child: ListTile(leading: Icon(Icons.location_on_outlined), title: Text('عناوين التوصيل'))),
      ],
    ),
  );
}
