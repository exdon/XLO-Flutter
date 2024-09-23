import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/stores/home_store.dart';

part 'filter_store.g.dart';

enum OrderBy { DATE, PRICE }

const VENDOR_TYPE_PARTICULAR = 1 << 0;
const VENDOR_TYPE_PROFESSIONAL = 1 << 1;

class FilterStore = _FilterStore with _$FilterStore;

abstract class _FilterStore with Store {
  _FilterStore(
      {this.orderBy = OrderBy.DATE,
      this.maxPrice,
      this.minPrice,
      this.vendorType = VENDOR_TYPE_PARTICULAR});

  @observable // definindo a variável como observable
  OrderBy orderBy;

  @action // declarando a função como uma action
  void setOrderBy(OrderBy value) => orderBy = value;

  @observable // definindo a variável como observable
  int? minPrice;

  @action // declarando a função como uma action
  void setMinPrice(int? value) => minPrice = value;

  @observable // definindo a variável como observable
  int? maxPrice;

  @action // declarando a função como uma action
  void setMaxPrice(int? value) => maxPrice = value;

  @computed
  String? get priceError =>
      maxPrice != null && minPrice != null && maxPrice! < minPrice!
          ? 'Faixa de preço inválida'
          : null;

  @action
  void selectVendorType(int value) => vendorType = value;

  void setVendorType(int type) => vendorType = vendorType | type;

  void resetVendorType(int type) => vendorType = vendorType & ~type;

  @observable
  int vendorType;

  @computed
  bool get isTypeParticular => (vendorType & VENDOR_TYPE_PARTICULAR) != 0;

  bool get isTypeProfessional => (vendorType & VENDOR_TYPE_PROFESSIONAL) != 0;

  @computed
  bool get isFormValid => priceError == null;

  void save() {
    GetIt.I<HomeStore>().setFilterStore(this as FilterStore);
  }

  FilterStore clone() {
    return FilterStore(
      orderBy: orderBy,
      minPrice: minPrice,
      maxPrice: maxPrice,
      vendorType: vendorType,
    );
  }
}
