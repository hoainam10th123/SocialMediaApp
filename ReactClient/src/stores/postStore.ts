import { makeAutoObservable, runInAction } from "mobx";
import agent from "../api/agent";
import { broadcastCommentService } from "../common/services/BroadcastCommentService";
import { IPagination, Pagination, PagingParams } from "../models/pagination";
import { IPost } from "../models/post";


export default class PostStore {
    posts: IPost[] = [];
    pagination: IPagination | null = null;
    pagingParams = new PagingParams();
    loadingInitial = false;
    hasMore = false;


    constructor() {
        makeAutoObservable(this);

        broadcastCommentService.getComment().subscribe(data => {           
            const post = this.posts.find(x=>x.id === data.postId)
            if(post){
                post.comments.push(data)
            }
        })
    }
    
    setPagingParams = (pagingParams: PagingParams)=>{
        this.pagingParams = pagingParams;
    }

    get axiosParams(){
        const params = new URLSearchParams();//URLSearchParams ko can import
        params.append('pageNumber', this.pagingParams.pageNumber.toString());
        params.append('pageSize', this.pagingParams.pageSize.toString());

        return params;
    }

    loadPosts = async () => {
        this.setLoadingInitial(true);
        try {
            const result = await agent.Posts.getPaginated(this.axiosParams);
            runInAction(()=>{                
                this.posts = result.data;
                this.pagination = new Pagination(result.pageNumber, result.pageSize, result.count, result.totalPages);
                this.setLoadingInitial(false);   
                this.hasMore = this.pagingParams.pageNumber < result.totalPages
            })
            //this.setPagination(result.pagination);
        } catch (error) {
            console.log(error);
            this.setLoadingInitial(false);
        }
    }

    loadMore =async () => {
        this.setLoadingInitial(true);
        try {
            if(this.pagingParams.pageNumber < this.pagination!.totalPages){
                this.pagingParams.pageNumber += 1;
                const result = await agent.Posts.getPaginated(this.axiosParams);                
                runInAction(()=>{              
                    this.posts = [...this.posts, ...result.data];
                    this.pagination = new Pagination(result.pageNumber, result.pageSize, result.count, result.totalPages);
                    this.setLoadingInitial(false);
                    this.hasMore = this.pagingParams.pageNumber < result.totalPages
                })
                //this.setPagination(result.pagination);
            }            
        } catch (error) {
            console.log(error);
            this.setLoadingInitial(false);
        }
    }

    setPagination = (pagination : IPagination)=>{
        this.pagination = pagination;        
    }

    setLoadingInitial = (state: boolean) =>{
        this.loadingInitial = state;
    }
}