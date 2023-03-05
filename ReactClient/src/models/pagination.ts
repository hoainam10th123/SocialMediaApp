export interface IPagination {
    pageNumber: number;
    pageSize: number;
    count: number;
    totalPages: number;
}

export class Pagination implements IPagination{
    pageNumber: number;
    pageSize: number;
    count: number;
    totalPages: number;

    constructor(pageNumber: number, pageSize: number, count: number, totalPages: number){
        this.pageNumber = pageNumber;
        this.pageSize = pageSize;
        this.count = count
        this.totalPages = totalPages;
    }
}

export class PaginatedResult<T> {
    data: T;
    pageNumber: number;
    pageSize: number;
    count: number;
    totalPages: number;

    // pagination: IPagination;

    // constructor(data: T, pagination: IPagination) {
    //     this.data = data;
    //     this.pagination = pagination;
    // }

    constructor(pageNumber:number, pageSize: number, count: number, totalPages: number, data: T) {
        this.data = data;
        this.pageNumber = pageNumber;
        this.pageSize = pageSize;
        this.count = count
        this.totalPages = totalPages;
    }
}

export class PagingParams {
    pageNumber;
    pageSize;

    constructor(pageNumber = 1, pageSize = 5) {
        this.pageNumber = pageNumber;
        this.pageSize = pageSize;
    }
}